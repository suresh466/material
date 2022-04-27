from .base import FunctionalTest
from selenium.webdriver.common.keys import Keys
from unittest import skip 

class ItemValidationTest(FunctionalTest):

    @skip
    def test_cannot_add_empty_list_items(self):
        # Edith gote to the home page and accidently tries to submit
        # an emtpy list item. She hits enter on the empty input box

        # The home page refreshes, and there is an error message
        # the list items cannot be blank

        # She then tries again with some text for the item,
        # which now works

        # perversely, she now decides to submit a second blank list item

        # She receives a similar warning on the list page

        # And she correct it by filling some text in
        self.fail('Write me!')
