object dmCore: TdmCore
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 379
  Width = 443
  object ti_userAuthenticated: TTimer
    Interval = 150
    OnTimer = ti_userAuthenticatedTimer
    Left = 32
    Top = 16
  end
end
