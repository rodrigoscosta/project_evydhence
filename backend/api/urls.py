from django.urls import path
from . import views

urlpatterns = [
    path('', views.getRoute),
    path('persons/', views.getPersons),
    path('persons/create', views.createPerson),
    path('persons/<int:pk>/update/', views.updatePerson),
    path('persons/<int:pk>/delete/', views.deletePerson),
    path('persons/<int:pk>/', views.getPerson)
]