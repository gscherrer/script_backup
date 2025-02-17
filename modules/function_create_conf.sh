# Function to create/overwrite the Restic password file
function create_restic_pwd_file {

  # Overwrite the password file with the default placeholder
  echo "INPUT_YOUR_RESTIC_REPO_PASSWORD_HERE" > "$RESTIC_PWD_FILE"
  echo "Restic password file created at $RESTIC_PWD_FILE. Edit it before launching the backup script again."
}

function create_db_others_file() {
  # Check if the db-others file exists, if not create it with sample content
  if [ ! -f "$OTHER_DBS_FILE" ]; then
    echo "# To backup other databases not related to WordPress, add lines to this file in the following format:" > "$OTHER_DBS_FILE"
    echo "# dbname;username;password" >> "$OTHER_DBS_FILE"
    echo "# Example:" >> "$OTHER_DBS_FILE"
    echo "# mydb1;myuser1;mypassword1" >> "$OTHER_DBS_FILE"
    echo "# mydb2;myuser2;mypassword2" >> "$OTHER_DBS_FILE"
  fi
} 

function create_pgdb_others_file() {
  # Check if the db-others file exists, if not create it with sample content
  if [ ! -f "$OTHER_PGDBS_FILE" ]; then
    echo "# This file is to backup PostGreSQL DB, add lines to this file in the following format:" > "$OTHER_PGDBS_FILE"
    echo "# dbname;username;password" >> "$OTHER_PGDBS_FILE"
    echo "# Example:" >> "$OTHER_PGDBS_FILE"
    echo "# mydb1;myuser1;mypassword1" >> "$OTHER_PGDBS_FILE"
    echo "# mydb2;myuser2;mypassword2" >> "$OTHER_PGDBS_FILE"
  fi
}

function create_file_exclude_directory (){
  # Create the excluded directories file if it doesn't exist
  if [ ! -f "$EXCLUDED_DIRS_FILE" ]; then
    echo "$HOME/scripts" >> "$EXCLUDED_DIRS_FILE"
    echo "$HOME/mail" >> "$EXCLUDED_DIRS_FILE"
    echo "$HOME/log" >> "$EXCLUDED_DIRS_FILE"
    echo "$HOME/etc" >> "$EXCLUDED_DIRS_FILE"
    echo "$HOME/ssl" >> "$EXCLUDED_DIRS_FILE"
    echo "$HOME/tmp" >> "$EXCLUDED_DIRS_FILE"
    echo "#You can get the path of all hidden directory by executing the following command while in your home directory:" >> "$EXCLUDED_DIRS_FILE"
    echo "#ls -dA .*/ | grep -Ev '^(\./|\.\./)$'" >> "$EXCLUDED_DIRS_FILE"
  fi
}