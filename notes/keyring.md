To fix the "unlock your keyring" popup issue when running Chrome on Ubuntu, you can try one of the following methods based on your preference for security and convenience:

### Method 1: Disable the Keyring Password (Less Secure)
This method makes it so that the keyring does not require a password, meaning that stored passwords are not encrypted.

1. **Install Seahorse**: This is a graphical interface for managing keyrings and passwords.
   ```bash
   sudo apt-get install seahorse
   ```

2. **Open Seahorse**: You can find it in the applications menu or run it from the terminal by typing `seahorse`.

3. **Find the 'Login' Keyring**: In Seahorse, go to `View` > `By Keyring`. Then look for the 'Login' keyring under `Passwords`.

4. **Change the Password**:
   - Right-click on the 'Login' keyring and select `Change Password`.
   - Set the new password to be empty (leave both password fields blank). Seahorse will warn you about storing passwords unencrypted. Confirm to proceed.

This should stop the keyring from prompting you for a password at login or when starting Chrome.

### Method 2: Use Chrome with the Basic Password Store (Less Secure)
This method avoids using the keyring altogether, meaning Chrome will store passwords in plain text.

1. **Modify Chrome Launcher**:
   - Edit the Chrome desktop entry file. You can edit either the global launcher or your personal launcher file:
     ```bash
     sudo nano /usr/share/applications/google-chrome.desktop
     ```
   - Find the `Exec` line and add `--password-store=basic` to the command. It should look something like this:
     ```
     Exec=/usr/bin/google-chrome-stable --password-store=basic %U
     ```

2. **Save and Exit**:
   - Save the file and exit the editor. This change will make Chrome store passwords in plain text, avoiding the keyring prompt.

### Method 3: Remove Keyring File (Less Secure)
This method removes the keyring file, which will force the creation of a new, potentially unprotected keyring.

1. **Remove Keyring File**:
   ```bash
   rm ~/.local/share/keyrings/login.keyring
   ```

2. **Restart Chrome**: The next time you start Chrome, it will prompt you to create a new keyring. Set the password to be empty (no password).

### Method 4: Ensure Keyring Unlocks Automatically at Login (More Secure)
This method ensures that your keyring unlocks automatically when you log into your computer.

1. **Set Up Automatic Login** (if not already set up):
   - Go to `Settings` > `User Accounts`.
   - Turn off `Automatic Login`.

2. **Sync Passwords**:
   - Make sure your user login password and keyring password are the same. If they are not, you can change the keyring password using Seahorse.

By following one of these methods, you should be able to disable the "unlock your keyring" popup when starting Chrome on Ubuntu.