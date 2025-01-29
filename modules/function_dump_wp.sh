function dump_wordpress_databases() {
  local ROOT_DIR=""
  local BACKUP_DIR=""
  local count=0

  echo "Search for Wordpress DB to dump: "

  # Parse arguments on assign root dir et backup dir
  while [ $# -gt 0 ]; do
    case "$1" in
      --root-dir=*)
        ROOT_DIR="${1#*=}"
        ;;
      --backup-dir=*)
        BACKUP_DIR="${1#*=}"
        ;;
      *)
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
    shift
  done

  # Check that both arguments are present
  if [ -z "$ROOT_DIR" ] || [ -z "$BACKUP_DIR" ]; then
    echo "Usage: dump_wordpress_databases --root-dir=ROOT_DIR --backup-dir=BACKUP_DIR"
    exit 1
  fi

  # Count the number of Prestashop installations in $ROOT_DIR
  for INSTALLATION_DIR in "$ROOT_DIR"/*/; do
    if [ -f "$INSTALLATION_DIR/app/config/parameters.php" ]; then
      count=$((count+1))
    fi
  done
  
  # Output the number of installations found or a message if none are found
  if [ $count -eq 0 ]; then
    echo "No Prestashop installations found in $ROOT_DIR"
  else
    echo "$count Prestashop DB found"
  fi

  # Dump the databases for each Prestashop installation
  for INSTALLATION_DIR in "$ROOT_DIR"/*/; do
    if [ -f "$INSTALLATION_DIR/app/config/parameters.php" ]; then
      # Extract the database connection details from w/app/config/parameters.php
      DATABASE=$(grep -oP "define\(\s*'database_name'\s*,\s*'\K[^']+" "$INSTALLATION_DIR/app/config/parameters.php")
      DB_USER=$(grep -oP "define\(\s*'database_user'\s*,\s*'\K[^']+" "$INSTALLATION_DIR/app/config/parameters.php")
      DB_PASSWORD=$(grep -oP "define\(\s*'database_password'\s*,\s*'\K[^']+" "$INSTALLATION_DIR/app/config/parameters.php")
      echo "Dumping database: $DATABASE"
      echo "User: $DB_USER"
      echo "Password: $DB_PASSWORD"
      # If a database name is found, create a backup file
      if [ -n "$DATABASE" ]; then
        DATE=$(date +"%Y-%m-%d")
        TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
        DUMP_FILE="${DATABASE}_${DATE}_${TIMESTAMP}.sql"
        if mysqldump --user="$DB_USER" --password="$DB_PASSWORD" --databases "$DATABASE" > "$BACKUP_DIR/$DUMP_FILE"; then
          gzip "$BACKUP_DIR/$DUMP_FILE"
          echo "[✓] Dump succeed for: $INSTALLATION_DIR"
        else
          echo "[X] Dump failed for: $INSTALLATION_DIR"
        fi
      fi
    fi
  done
}