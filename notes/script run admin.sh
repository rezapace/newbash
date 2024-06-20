To allow a script to run with `sudo` without prompting for a password, you need to modify the sudoers file. This can be done by adding a specific rule to the sudoers file to grant passwordless execution of your script. Here's how you can do this:

1. **Open the sudoers file using visudo**:
   - Open a terminal and run:
     ```bash
     sudo visudo
     ```
   - This command safely opens the sudoers file in an editor (usually nano or vi) and prevents syntax errors.

2. **Add a rule to allow passwordless execution**:
   - Add the following line to the end of the sudoers file:
     ```
     r ALL=(ALL) NOPASSWD: /home/r/Documents/Backups/hibernate.sh
     ```
   - Replace `r` with your actual username if it's different.

3. **Save and exit**:
   - If you're using `nano`, you can save and exit by pressing `Ctrl+X`, then `Y`, and `Enter`.
   - If you're using `vi`, press `Esc`, then type `:wq`, and press `Enter`.

### Example of a Modified Sudoers File

The added line in the sudoers file might look something like this:

```plaintext
# User privilege specification
root    ALL=(ALL:ALL) ALL
r       ALL=(ALL) NOPASSWD: /home/r/Documents/Backups/hibernate.sh
```

### Complete Script and Desktop Entry

Your script (`hibernate.sh`):

```bash
#!/bin/bash

# Skrip untuk menjalankan hibernate
sudo pm-hibernate
```

Your desktop entry (`Hibernate.desktop`):

```ini
[Desktop Entry]
Version=1.0
Type=Application
Name=Hibernate
Exec=/home/r/Documents/Backups/hibernate.sh
Icon=/path/to/restart-icon.png
Terminal=false
```

### Summary

By adding the appropriate line to the sudoers file, you allow the `hibernate.sh` script to be executed with `sudo` without requiring a password. This will enable your desktop entry to run the script without prompting for a password.