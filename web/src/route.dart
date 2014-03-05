part of ompa_html;

void ompaRouteInitializer(Router router, ViewFactory views) {
  views.configure({
    'success': ngRoute(
        path: '/success',
        view: 'view/success.html'),
    'note': ngRoute(
        path: '/note',
        view: 'view/note.html')
  });
}