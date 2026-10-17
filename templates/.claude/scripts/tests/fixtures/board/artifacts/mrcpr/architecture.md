# mrcpr — architecture (rev 1)

## Components

| Component | Kind | Package › module | Change | Role |
|---|---|---|---|---|
| `ModuleSettingsDialog` | struct | app › module::alpha::settings_dialog | new | four `RangeSpec` inputs (holding, input, coils, discrete), live error box, close confirmation; `resolve` → `Result<ReadRanges, String>`, `confirm` → `Option<ReadRanges>` |
| `RangeSpec` | struct | app › module::alpha::settings_dialog | new | `Validate` impl over `check_range_spec` for one range input |
| `ModbusModuleView::apply_read_ranges` | fn | app › module::alpha::view::mutate | new | async, `&mut self`; writes one `ReadRanges` to the device config and the running module |
| `ModbusViewOverlay` | enum | app › module::alpha::view | changed | new `Settings(Box<ModuleSettingsDialog>)` variant |
| `PendingAction` | enum | app › module::alpha::view::overlay | changed | new `SetReadRanges(ReadRanges)` variant, applied in refresh |
| `ModbusCmd` | enum | app › module::alpha::view | changed | new `Module` variant, 13 commands |

## Decisions
