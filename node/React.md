
- [React Developer Tool](https://chromewebstore.google.com/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi)


# Useful

```bash
# https://docs.fontawesome.com/web/dig-deeper/svg-core/
npm i --save @fortawesome/fontawesome-svg-core
npm i --save @fortawesome/free-brands-svg-icons
npm i --save @fortawesome/free-solid-svg-icons
npm i --save @fortawesome/free-regular-svg-icons
# 
```


# React cli

```bash
### init React App (自行決定 npm OR yarn)
npx create-react-app --template typescript ${ReactApp} 
yarn create react-app ${ReactApp}


### 產生 react component
# https://www.npmjs.com/package/generate-react-cli
npx generate-react-cli component $ComponentName


### 
```


# Basic

```jsx
// 產生一個 空的 Element
<React.Fragment>xxx</React.Fragment>
// 等同於 
<>xxx</>
// 用途: 因為 React Component 都必須用 Element 包起來 (容易產生一堆不必要的層級及 Element)
```

```jsx
// 起手式(基本上一開始就會有了, 無需自行處理)
const root = ReactDOM.createRoot( document.getElementById('root') as HTMLElement );
root.render(<App />);


// 
const element = React.createElement(
    "html_tag_string", 
    {html_tag_prop_key: html_tag_prop_value}, 
    "child_props");

ReactDOM.render(element, document.getElementById('root'));


// useState
import React, { useState } from 'react';
const [status, setStatus] = useState('<data_init_value>');


// useEffect - 接收一個 fn(會在畫面轉譯完成後被呼叫)
import { useEffect } from 'react';
useEffect(() => {});
```
