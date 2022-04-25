from django.shortcuts import redirect, render
from django.http import HttpResponse

from lists.models import List, Item

# Create your views here.

def home_page(request):
    template = 'lists/home.html'

    return render(request, template)

def view_list(request):
    template = 'lists/list.html'

    items = Item.objects.all()
    context = {'items': items}

    return render(request, template, context)

def new_list(request):
    list_ = List.objects.create()
    new_item_text = request.POST['item_text']
    Item.objects.create(text=new_item_text, list=list_)
    return redirect('/lists/the-only-list-in-the-world/')
