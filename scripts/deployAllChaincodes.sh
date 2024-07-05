# cd ../api-2.0/

# pm2 stop 0

# cd ../artifacts/

# echo "Stopping and removing containers..."
# docker-compose down -v

# echo "Starting containers..."
# docker-compose up -d

# cd ../scripts/

echo "Environment reset and containers started. Ready for deployment sequence."

./createChannel.sh &&
sleep 5

./createChannel2.sh &&
sleep 5

./deployProject.sh &&
sleep 5

./deployAsset.sh &&
sleep 5

./deploy_erc3525.sh &&
sleep 5

./deploy_erc20.sh &&
sleep 5

cd ../api-2.0/

pm2 start 0

pm2 startup  

pm2 save


