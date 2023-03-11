
## How to setup

We need to pass the `DISCORD_WEBHOOK` url into this action.

1. Go to channel settings for the notifications channel in discord

<img width="296" alt="Screenshot 2023-03-12 at 8 09 35" src="https://user-images.githubusercontent.com/277819/224515462-1d234c60-cb24-437c-9456-1fd2939e0dce.png">

2. Go to `Integrations > Webhooks`, and click "New Webhook"

<img width="571" alt="Screenshot 2023-03-12 at 8 10 52" src="https://user-images.githubusercontent.com/277819/224515614-690ab375-aead-4927-9df6-c6bea4500bf2.png">

3. Open the new webhook and click "Copy Webhook URL"

<img width="669" alt="Screenshot 2023-03-12 at 8 12 20 (2)" src="https://user-images.githubusercontent.com/277819/224515633-3e83b57f-33af-48dc-b035-614cfe76f83e.png">

4. Add the secret to github actions:

![Screenshot 2023-03-12 at 8 17 59](https://user-images.githubusercontent.com/277819/224515693-d28e6697-38ef-4f97-9872-080709acdfe3.png)

---

## Examples

****Still failing****

<img width="519" alt="Screenshot 2023-03-12 at 8 07 06" src="https://user-images.githubusercontent.com/277819/224515772-8adcde46-3769-4585-a911-8fb68ac3b2dd.png">

****Fixed****

<img width="430" alt="Screenshot 2023-03-12 at 8 07 27" src="https://user-images.githubusercontent.com/277819/224515788-a3803878-50ce-4eb5-877e-e8ccd62a0a19.png">

 **(Using v1 output, compressed repo/branch into title like BK notifs in v4)**
