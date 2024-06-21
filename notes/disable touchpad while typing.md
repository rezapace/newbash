Disabling the touchpad while typing in Linux Mint MATE can help prevent accidental cursor movements and clicks. Here’s how you can achieve this:

### Method 1: Using `xinput`

1. **Identify your touchpad device name:**
   - Open a terminal.
   - Run the command:
     ```bash
     xinput list
     ```
   - Look for the name of your touchpad device in the output. It might look something like "SynPS/2 Synaptics TouchPad".

2. **Disable touchpad while typing:**
   - Once you have the name or ID of your touchpad, run the command:
     ```bash
     xinput set-prop "Device Name" "Device Enabled" 0
     ```
     Replace `"Device Name"` with the actual name or ID of your touchpad.

3. **Enable touchpad after typing:**
   - To re-enable the touchpad, use:
     ```bash
     xinput set-prop "Device Name" "Device Enabled" 1
     ```
     Replace `"Device Name"` with the actual name or ID of your touchpad.

### Method 2: Using `syndaemon`

1. **Install `syndaemon` if it is not already installed:**
   - Open a terminal.
   - Run the command:
     ```bash
     sudo apt-get install xserver-xorg-input-synaptics
     ```

2. **Run `syndaemon`:**
   - Execute the following command to disable the touchpad while typing:
     ```bash
     syndaemon -i 1 -t -K -R
     ```
     - `-i 1`: Specifies the idle time (in seconds) after the last key press before enabling the touchpad again.
     - `-t`: Only disable tapping and scrolling, not mouse movements.
     - `-K`: Ignore modifier keys when monitoring keyboard activity.
     - `-R`: Run `syndaemon` in the background.

3. **Make `syndaemon` start at login:**
   - Open "Startup Applications" from the menu.
   - Click "Add".
   - Name it "Syndaemon" and put the command:
     ```bash
     syndaemon -i 1 -t -K -R
     ```
   - Click "Add" again and then "Close".

### Method 3: Using GUI (if available)

1. **Open `Mouse and Touchpad` settings:**
   - Go to "Menu" -> "Control Center" -> "Mouse".

2. **Adjust the settings:**
   - Navigate to the "Touchpad" tab.
   - Look for an option like "Disable touchpad while typing" and enable it.

### Method 4: Custom Script

1. **Create a script to disable/enable the touchpad:**
   - Open a terminal and create a script file:
     ```bash
     nano ~/disable-touchpad-while-typing.sh
     ```

2. **Add the following content:**
   ```bash
   #!/bin/bash
   syndaemon -i 1 -t -K -R
   ```

3. **Make the script executable:**
   ```bash
   chmod +x ~/disable-touchpad-while-typing.sh
   ```

4. **Run the script at startup:**
   - Open "Startup Applications" from the menu.
   - Click "Add".
   - Name it "Disable Touchpad While Typing" and put the command:
     ```bash
     ~/disable-touchpad-while-typing.sh
     ```
   - Click "Add" again and then "Close".

Using these methods, you can effectively disable the touchpad while typing on Linux Mint MATE.