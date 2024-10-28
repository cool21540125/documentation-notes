
# custom data example

- https://stackoverflow.com/questions/68018173/customize-datakey-values
- https://www.paigeniedringhaus.com/blog/build-and-custom-style-recharts-data-charts
- 


# XAxis

- tickFormatter
    - The formatter function of tick.
    - 用來重新定義 X 軸的單位樣式

```jsx
<XAxis dataKey="date" tickFormatter={dateFormatXAxis} />
// 接收到 "2024-04-28", 轉換成 "2024/04"

const dateFormatXAxis = (date: string) =>  moment(date).format("YYYY/MM")
```


# YAxis

- scale (default: auto)
    - `'auto' | 'linear' | 'pow' | 'sqrt' | 'log' | 'identity' | 'time' | 'band' | 'point' | 'ordinal' | 'quantile' | 'quantize' | 'utc' | 'sequential' | 'threshold' | Function`
    - If 'auto' set, the scale function is decided by the type of chart, and the props type.
    - 設定 `log` 的話無法使用, 即使遵照 https://github.com/recharts/recharts/issues/575
        - `<YAxis scale="log" domain={['auto', 'auto']} />` (一樣無法使用, 原因不明)

```jsx

```


# Tooltip


# Cartesian Components

## Brush

- 圖表底下的小區塊, 拖拉以後用來縮放圖表的 X 軸區間


## CartesianGrid

```jsx
// Charts 呈現格線
<CartesianGrid strokeDasharray="7 7" />
```




## AreaChart

### Area - https://recharts.org/en-US/api/Area

- stackId (optional)
    - `String | Numberoptional`
    - The stack id of area, when two areas have the same value axis and same stackId, then the two areas area stacked in order.

```jsx
<Area legendType="cross" label dataKey={getCentralValue} stroke="pink" />
// stroke   : 填滿顏色
// stackId  : 做出堆疊的群組 (設定一樣就好了)
```


## BarChart

### Bar - https://recharts.org/en-US/api/Bar

- legendType (Default: line)
    - `'line' | 'plainline' | 'square' | 'rect'| 'circle' | 'cross' | 'diamond' | 'square' | 'star' | 'triangle' | 'wye' | 'none'optional`
    - 可針對個別 Area/Line/Bar 設定它的 legend. 仔細想想, 提出到 Legend 設定似乎是比較好的做法
- onClick
    - 

```jsx
// 
<Bar label dataKey={getRedValue}  stackId="1" fill="red" />
<Bar label dataKey={getBlueValue} stackId="1" fill="blue" />
// label    : (mouthOn) 呈現數據
// fill     : 填滿顏色
// stroke   : (使用 fill 就是了, 這個只是外誆)
// dataKey  :
// data     : position information
// stackId  : 做出堆疊的群組 (設定一樣就好了)
```
