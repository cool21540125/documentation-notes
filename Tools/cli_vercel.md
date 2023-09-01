
# Install & Login

```bash
### Install
brew install -g vercel


vercel --version
#Vercel CLI 31.0.3
#31.0.3


### 
vercel login
vercel logout
```


# vercel CLI

```bash
export VERCEL_TOKEN=
export VERCEL_TEAM_ID=
export VERCEL_PROJECT=


### 列出目前有哪些 Projects
vercel --scope $VERCEL_TEAM_ID --token=$VERCEL_TOKEN project ls


### link
vercel link --yes --scope $VERCEL_TEAM_ID --token $VERCEL_TOKEN --project $VERCEL_PROJECT

### pull
vercel pull --yes --token $VERCEL_TOKEN

### build
vercel build --prod --token $VERCEL_TOKEN

### 
vercel deploy --prebuilt --prod --token=$VERCEL_TOKEN
```
