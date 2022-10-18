# [VSCode套件 - Markdown Preview Mermaid Support](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-mermaid)
- 2018/08/04
- VSCode版本 1.25.0
- 套件版本 1.0.0
- [mermaidjs - github.io](https://mermaidjs.github.io/)
- [mermaidjs - 有點完整的教學](https://mermaidjs.github.io/gantt.html)
- [Diagram Guide](https://kubernetes.io/docs/contribute/style/diagram-guide/)


# 基本

語法:

    ```mermaid
    graph LR;
        A --> B;
        A --> C;
        B --> C;
    ```

可以看到如下圖:

```mermaid
graph LR;
    A --> B;
    A --> C;
    B --> C;
```

`graph TD` 用來描述此區塊的流程圖的 `方向` : `TD (上到下)` 及 `LR (左到右)`


## 也可以做出 `子區塊(subgraph)`, 並製作 `關聯關係`

```mermaid
graph TD

MrWang -- ??? --- MsLin

subgraph 王家
    MrWang[王先生] -- 夫妻 --- MrsWang[王太太]
end

subgraph 林家
    MsLin[林小姐]
end
```



# 進階一點的官方範例 - 不解釋 (因為還沒用到)

```mermaid
%% Example of sequence diagram
  sequenceDiagram
    Alice->>Bob: Hello Bob, how are you?
    alt is sick
    Bob->>Alice: Not so good :(
    else is well
    Bob->>Alice: Feeling fresh like a daisy
    end
    opt Extra response
    Bob->>Alice: Thanks for asking
    end
```

```mermaid
gantt
       dateFormat  YYYY-MM-DD
       title Adding GANTT diagram functionality to mermaid

       section A section
       Completed task            :done,    des1, 2014-01-06,2014-01-08
       Active task               :active,  des2, 2014-01-09, 3d
       Future task               :         des3, after des2, 5d
       Future task2              :         des4, after des3, 5d

       section Critical tasks
       Completed task in the critical line :crit, done, 2014-01-06,24h
       Implement parser and jison          :crit, done, after des1, 2d
       Create tests for parser             :crit, active, 3d
       Future task in critical line        :crit, 5d
       Create tests for renderer           :2d
       Add to mermaid                      :1d

       section Documentation
       Describe gantt syntax               :active, a1, after des1, 3d
       Add gantt diagram to demo page      :after a1  , 20h
       Add another diagram to demo page    :doc1, after a1  , 48h

       section Last section
       Describe gantt syntax               :after doc1, 3d
       Add gantt diagram to demo page      :20h
       Add another diagram to demo page    :48h
```