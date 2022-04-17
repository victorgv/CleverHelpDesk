object dmCore: TdmCore
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 150
  Width = 215
  object ti_userAuthenticated: TTimer
    Interval = 150
    OnTimer = ti_userAuthenticatedTimer
    Left = 32
    Top = 16
  end
end
