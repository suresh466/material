from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import time
import unittest

class NewVisitorTest(unittest.TestCase):

    def setUp(self):
        self.browser = webdriver.Firefox()

    def tearDown(self):
        self.browser.quit()

    def test_can_start_a_list_and_retrieve_it_later(self):
        # Edith heard about some to-do app online so she visited its homepage.
        self.browser.get('http://localhost:8000')

        # She notices that the title of the app says todo app.
        self.assertIn('To-Do', self.browser.title)
        header_text = self.browser.find_element_by_tag_name('h1').text
        self.assertIn('To-Do', header_text)

        # She is invited to enter a todo item right away.
        inputbox = self.browser.find_element_by_id('id_new_item')
        self.assertEqual(
            inputbox.get_attribute('placeholder'),
            'Enter a to-do item'
        )

        # She entered "Buy peacock feathers" into a text box
        # (her hobby is tying fly-fishing lures).
        inputbox.send_keys('Buy peacock feathers')

        # When she hits enter the page updates and the entry is displayed as:
        # "1:  Buy peacock feathers" as an item in the todo list.
        inputbox.send_keys(Keys.Enter)
        time.sleep(1)
        table = self.browser.find_element_by_id('id_list_table')
        rows = table.find_elements_by_tag('tr')
        self.assertTrue(
            any(row.text == '1: Buy peacock feathers' for row in rows)
        )

        # There is still a text box inviting her to add another item. She enters
        # "Use peacock feathers to make a fly" (Edith is very methodical).
        self.fail('Finish the test!')

# The site updates again and now shows both items on the list.

# She wonders if the website remembers her todo items and notices the website has
# generated her a unique url address -- there is some explanatory text to that effect.

# she visits the url and is releived to see the todo list intact.

# Finally she goes to sleep being assured.

if __name__ == '__main__':
    unittest.main()
