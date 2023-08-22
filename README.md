# action-discord

This action is designed to be a very simple step you add to an existing job in order to send a notification to discord when it fails.

<img width="414" alt="Screenshot 2023-08-23 at 8 47 34" src="https://github.com/zzak/action-discord/assets/277819/b21973c2-7230-4153-9030-46bd3a74040e">

```yaml
# Only notify when fail on main branch
- uses: zzak/action-discord@v6
  if: failure() && github.ref_name == 'main'
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
    webhook: ${{ secrets.DISCORD_WEBHOOK }}
```

---

## How to setup

We need to pass the `DISCORD_WEBHOOK` url into this action.

### 1. Go to channel settings for the notifications channel in discord

<img width="296" alt="Screenshot 2023-03-12 at 8 09 35" src="https://user-images.githubusercontent.com/277819/224515462-1d234c60-cb24-437c-9456-1fd2939e0dce.png">

### 2. Go to `Integrations > Webhooks`, and click "New Webhook"

<img width="571" alt="Screenshot 2023-03-12 at 8 10 52" src="https://user-images.githubusercontent.com/277819/224515614-690ab375-aead-4927-9df6-c6bea4500bf2.png">

### 3. Open the new webhook and click "Copy Webhook URL"

<img width="669" alt="Screenshot 2023-03-12 at 8 12 20 (2)" src="https://user-images.githubusercontent.com/277819/224515633-3e83b57f-33af-48dc-b035-614cfe76f83e.png">

### 4. Add the secret to github actions:

![Screenshot 2023-03-12 at 8 17 59](https://user-images.githubusercontent.com/277819/224515693-d28e6697-38ef-4f97-9872-080709acdfe3.png)

