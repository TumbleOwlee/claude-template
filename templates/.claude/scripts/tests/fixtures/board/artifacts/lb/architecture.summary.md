# lb — architecture summary (rev 1)

Decide: 3 new components in charging; an `Allocator` over a tree of `Node`s

Interfaces: 3 new — sketches in architecture.md `## Interfaces`

| Component | Kind | Module | Change | Role |
|---|---|---|---|---|
| `Allocator` | struct | charging | new | splits a limit over the tree |
| `Device` | interface | charging | new | demand and capability of one device |

Public surface:
- config key `site_limit_a`

Open: none
