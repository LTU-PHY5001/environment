#Delete the tag on any remote before you push
git push origin :refs/tags/VDI
#Replace the tag to reference the most recent commit
git tag -fa VDI -m "Updated for VDI deployment"
#Push the tag to the remote origin
git push origin main --tags