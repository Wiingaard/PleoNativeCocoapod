# Keychain

A simple wrapper around the iOS Keychain.

## Note for implementation
To share a key between App and Share Extension: 
- Include both targets in the same "App Group":
    1. Create app group on Apple Developer Console (under app identifier -> App Group).
    2. Assign it to app identifier in Apple Developer Console.
    3. Add "App Group" capability in Xcode, and select the recently created app group.
- Add "Keychain Sharing" in Xcode. Use the Main apps bundle id as keychain group for both targets.
- No need to pass `accessGroup` to KeychainClient.
