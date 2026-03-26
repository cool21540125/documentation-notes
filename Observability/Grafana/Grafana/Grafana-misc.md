# Grafana 雜項知識

## Grafana console - drilldown > trace

在 Grafana drilldown 點開 trace 以後, Grafana 會對 Tempo 發出底下請求, Tempo 會從 Storage 尋找 traces

  GET /api/v2/traces/{traceID}?start={from - Xtime}&end={to + Ytime}

Grafana 可藉由 datasources.yaml 做配置, 來約束 Tempo 是否做限定時間範圍的搜尋

  - name: Tempo
    jsonData:
      search:
        traceQuery:
          spanEndTimeShift: 30m
          spanStartTimeShift: "-30m"
          timeShiftEnabled: true

