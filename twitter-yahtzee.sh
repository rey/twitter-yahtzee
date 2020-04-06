#!/bin/bash

# twitter-yahtzee.sh
#
# About Pointless script to roll 5 dice and update your twitter profile

dice_1=⚀
dice_2=⚁
dice_3=⚂
dice_4=⚃
dice_5=⚄
dice_6=⚅
yahtzee=1

for ((counter=1; counter<=5; counter++)) do
  # Roll the dice and assign to `dice_value`
  # Also, this is "random" as opposed to random #yolo
  dice_value=$((1 + $RANDOM % 6))

  # Push `dice_value` into an array in the form "dice_x"
  hand[${counter}]=dice_${dice_value}

  # If this isnt the first dice roll and yahtzee is still on the cards
  if [[ ! $counter == 1 ]] && [[ ${yahtzee} == 1 ]]; then

    # If the current `dice_value` is not the same as the previous `dice_value` then
    # Yahtzee is off the cards
    if [[ ! ${dice_value} == ${hand[-2]#dice_} ]]; then
      yahtzee=0
    fi

  fi
done

# For logging purposes
echo "${hand[1]#dice_} ${hand[2]#dice_} ${hand[3]#dice_} ${hand[4]#dice_} ${hand[5]#dice_}"

score_card="${!hand[1]} ${!hand[2]} ${!hand[3]} ${!hand[4]} ${!hand[5]}"

# Update twitter profile with the hand in the form "⚀ ⚁ ⚀ ⚁ ⚃"
twurl \
    --consumer-key ${twitter_consumer_api_key} \
    --consumer-secret ${twitter_consumer_api_secret_key} \
    --access-token ${twitter_access_token} \
    --token-secret ${twitter_access_token_secret} \
    --request-method POST \
      "/1.1/account/update_profile.json?description=${score_card}&skip_status=true&include_entities=false"

# If a Yahtzee is rolled(!) then post to twitter
 if [[ ${yahtzee} == 1 ]]; then
  twurl \
    --consumer-key ${twitter_consumer_api_key} \
    --consumer-secret ${twitter_consumer_api_secret_key} \
    --access-token ${twitter_access_token} \
    --token-secret ${twitter_access_token_secret} \
    --request-method POST \
    "/1.1/statuses/update.json?status=🎲 I rolled a Yahtzee! ${score_card}&trim_user=1"
fi