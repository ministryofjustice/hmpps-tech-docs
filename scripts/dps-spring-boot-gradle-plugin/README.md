# Scripts for DPS Spring Boot Gradle Plugin

These scripts make it easier to bulk upgrade a number of repos with the latest Spring Boot Gradle Plugin version

Steps to run:

1. Review `repos-to-upgrade` and make sure your repos are there
2. Check the version you want to upgrade to is correct in `upgrade-latest.bash`
3. Update the `BRANCH_NAME` and `COMMIT_MESSAGE` in `upgrade-all-latest.bash`
4. Run the script with
```bash
./upgrade-all-latest.bash
```
5. Check the output of the generated file `pull_requests_created.txt` and share the PR links in #dps_dev for folks to review