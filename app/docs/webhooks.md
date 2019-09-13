# Strava Webhooks

## Register Webhook

```bash
curl -X POST https://api.strava.com/api/v3/push_subscriptions \
      -F client_id=14097 \
      -F client_secret=xxx \
      -F 'callback_url=https://4808b152.ngrok.io/webhooks' \
      -F 'verify_token=xxx'
```

this will send a verification request: `GET callback_url` that must be responded with `json: { 'hub.challenge' => params['hub.challenge'] }` in under 2 seconds.

## Delete Webhook Subscription

```bash
curl -X DELETE https://api.strava.com/api/v3/push_subscriptions/12345 \
    -F client_id=5 \
    -F client_secret=7b2946535949ae70f015d696d8ac602830ece412
```

## Debugging

send hook manually:

```bash
curl -X POST https://4808b152.ngrok.io/webhooks -H 'Content-Type: application/json' \
 -d '{
      "aspect_type": "create",
      "event_time": 1549560669,
      "object_id": 0,
      "object_type": "activity",
      "owner_id": 9999999,
      "subscription_id": 999999
    }'
```
