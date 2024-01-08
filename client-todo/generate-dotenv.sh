rm -f .env.local 
azd env get-values > .env.local
#ls -la > ls-generate-dotenv.txt
azd package