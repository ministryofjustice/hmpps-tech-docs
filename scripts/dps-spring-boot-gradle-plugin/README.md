# Scripts for DPS Spring Boot Gradle Plugin

These scripts make it easier to bulk upgrade a number of repos with the latest Spring Boot Gradle Plugin version

Steps to run:

1. Review `repos-to-upgrade` and add the names of the repos you wish to upgrade
2. Ensure you have all the repos checked out locally and with the same directory name 
3. Check the version you want to upgrade to is correct in `upgrade-latest.bash`
4. Update the `BRANCH_NAME` and `COMMIT_MESSAGE` in `upgrade-all-latest.bash`
5. Run the script with
```bash
./upgrade-all-latest.bash
```
6. Check the output of the generated file `pull_requests_created.txt` and share the PR links in #dps_dev for folks to review