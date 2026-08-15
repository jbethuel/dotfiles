# Git

```
# Generate keys
ssh-keygen -t rsa -b 4096

# Sample clone
git clone <User>@<Host>:<Username|Org>/repo.git
git clone git@github:/jbethuel/dotfiles.git

# Test the connection
ssh -T <Host>

# Git identity
git config user.name "Your Name"
git config user.email "personal@email.com"

# Add SSH to agent
ssh-add ~/.ssh/work

# List SSH in agent
ssh-add -l

# Clear SSH in agent
ssh-add -D
```
