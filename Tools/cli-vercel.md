

```bash
### Install
brew install -g vercel


vercel --version
#Vercel CLI 31.0.3
#31.0.3


### 
vercel login


### 
vercel pull --yes --environment=production --token=$VERCEL_TOKEN
vercel build --prod --token=$VERCEL_TOKEN
vercel deploy --prebuilt --prod --token=$VERCEL_TOKEN 
```
