part of ompa_html;

void ompaRouteInitializer(Router router, ViewFactory views) {
  views.configure({
    'add': ngRoute(
        path: '/success',
        view: 'view/success.html')
  });
}