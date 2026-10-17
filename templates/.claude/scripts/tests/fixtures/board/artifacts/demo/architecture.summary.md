# demo — architecture summary (rev 1)

Decide: 1 new, 1 changed components in netclient; `ReconnectPolicy` owned by the client task

Interfaces: 1 new, 1 changed — sketches in architecture.md `## Interfaces`

| Component | Kind | Module | Change | Role |
|---|---|---|---|---|
| `ReconnectPolicy` | struct | netclient | new | backoff 1s to 30s |
| `ConnectedCell` | struct | netclient | changed | holds a three-state `ConnState` |

Public surface:
- `ClientError::Reconnecting`

Decisions taken (confirm):
- policy owned by the client task — RTU and TCP share it

Open: none
