part of ompa_html;

@Injectable()
void ompaRouteInitializer(Router router, RouteViewFactory views) {
  views.configure({
    'success': ngRoute(
        path: '/success',
        view: 'view/success.html'),
    'note': ngRoute(
        path: '/note',
        view: 'view/note.html'),
    'task': ngRoute(
        path: '/task',
        view: 'view/task.html')
  });
}