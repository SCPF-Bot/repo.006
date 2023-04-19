#!/bin/bash

# Set up variables for the ChatGPT API URL and access token
CHATGPT_API_URL="https://api.chatgpt.com/v1/chat"
CHATGPT_ACCESS_TOKEN="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"

# Set up variables for the Facebook Messenger API URL and access token
MESSENGER_API_URL="https://graph.facebook.com/v12.0/me/messages"
MESSENGER_ACCESS_TOKEN="EAAIy8KNRA3oBAI6320jZA8gFN92pGiJqGeEtgTnZAT9KZBUVc7Skem3jtf7yO1lls90D8lSTbeXcXoxcZAsJ5Prbk6ZCxip56ah8uVheWmZA8vMZAorKWsJdadbCESBt2nDG787FMxLQ0xjiTvy3mRUJ0U5q08kFwPJVMfei4ydR00uwvGx8ZBZAQi6wIrT42E2pIB0XtxNQLTQZDZD"

# Set up a variable for the Facebook Messenger webhook verification token

MESSENGER_VERIFY_TOKEN="YOUR_FACEBOOK_MESSENGER_API_VERIFY_TOKEN"

# Define a function to send messages to Facebook Messenger
function send_message() {
  local recipient_id="$1"
  local message="$2"
  local post_data=$(printf '{"recipient": {"id": "%s"}, "message": {"text": "%s"}}' "$recipient_id" "$message")
  curl -s -X POST -H "Content-Type: application/json" -d "$post_data" "$MESSENGER_API_URL?access_token=$MESSENGER_ACCESS_TOKEN"
}

# Start a loop to continuously check for incoming messages
while true; do
  # Get the last message sent to the Facebook Messenger webhook
  web_request=$(curl -s -X GET "https://graph.facebook.com/v12.0/$MESSENGER_WEBHOOK_ID/messages?access_token=$MESSENGER_ACCESS_TOKEN")

  # Extract the text of the last message from the JSON object
  message_text=$(echo $web_request | jq -r '.data[0].messaging[0].message.text')

  # Get the sender ID of the last message sent to the webhook
  sender_id=$(echo $web_request | jq -r '.data[0].messaging[0].sender.id')

  # Check if the last message sent has text
  if [ -n "$message_text" ]; then
    # Send the message to the ChatGPT API and get a response
    response=$(curl -s -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $CHATGPT_ACCESS_TOKEN" -d '{"message":"'${message_text}'"}' $CHATGPT_API_URL)

    # Extract the response from the JSON object
    response_text=$(echo $response | jq -r '.response')

    # Send the response back to Facebook Messenger
    send_message "$sender_id" "$response_text"
  fi

  # Check if the last web request was a verification request
  if [[ $(echo $web_request | jq -r '.object') == "page" ]]; then
    # Verify the webhook by responding with the challenge code
    challenge_code=$(echo $web_request | jq -r '.entry[0].messaging[0].checkout_update.payload')
    if [ "$challenge_code" == "$MESSENGER_VERIFY_TOKEN" ]; then
      challenge_response=$(echo $web_request | jq -r '.entry[0].messaging[0].checkout_update.sender_id')
      send_message "$challenge_response" "Challenge accepted."
    fi
  fi

  # Sleep for a few seconds before checking for new messages again
  sleep 5
done

# This script sets up a loop to continuously check for incoming messages on the Facebook Messenger webhook, sends each incoming message to the ChatGPT API, and responds to the sender with the generated response. The script also includes code to verify the Facebook Messenger webhook if a verification request is received. This is just an example and will need to be adapted to fit your specific ChatGPT and Facebook Messenger access settings.
