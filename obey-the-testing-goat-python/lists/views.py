from django.core.exceptions import ValidationError
from django.shortcuts import redirect, render
from django.http import HttpResponse

from lists.models import List, Item

# Create your views here.

def home_page(request):
    template = 'lists/home.html'

    return render(request, template)

def view_list(request, list_id):
    template = 'lists/list.html'
    list_ = List.objects.get(id=list_id)
    error = None

    if request.method == 'POST':
        try:
            item = Item(text=request.POST['item_text'], list=list_)
            item.full_clean()
            item.save()
            return redirect(list_)
        except ValidationError:
            error = "You can't have an empty list item"
    context = {'list': list_, 'error': error}
    return render(request, template, context)

def new_list(request):
    list_ = List.objects.create()
    new_item_text = request.POST['item_text']
    item = Item(text=new_item_text, list=list_)
    try:
        item.save()
        item.full_clean()
    except ValidationError:
        list_.delete()
        error = "You can't have an empty list item"
        return render(request, 'lists/home.html', {"error": error})

    return redirect(list_)
