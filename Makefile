deploy:
	.scripts/deploy.sh

backup_master_secret:
	.scripts/sealed-secrets-backup.sh

restore_master_secret:
	.scripts/sealed-secrets-restore.sh

secret:
	.scripts/secret.sh
