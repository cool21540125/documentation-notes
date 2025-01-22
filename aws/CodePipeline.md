# AWS CodePipeline

- 建置 CodePipeline 的時候, 必須選怎其中一種 Execution mode:
  - Superseded : (前一次 Pipeline 還在執行中) 後面一次的 Pipeline 會把前面的中斷, 已較新的為主
  - Queued : (前一次 Pipeline 還在執行中) 後面一次的 Pipeline 會等前面的跑完, 再來跑新的
  - Parallel : (前一次 Pipeline 還在執行中) 後面一次的 Pipeline 會與前面的 Pipeline 一起平行執行
