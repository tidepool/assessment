class UserDashboard.Views.HomeTabView extends UserDashboard.Views.BaseTabView

  template: JST['dashboard/tabs/home_tab_view']

  views:
    'BadgeView': 'UserDashboard.Views.BadgeView'
    'UpcomingView': 'UserDashboard.Views.UpcomingView'
    'HistoryView': 'UserDashboard.Views.HistoryView'

