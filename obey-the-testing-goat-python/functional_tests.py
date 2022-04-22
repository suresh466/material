from selenium import webdriver
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
        self.fail('Finish the test!')

# She is invited to enter a todo item right away.

# She entered "Buy peacock feathers" into a text box (her hobby is tying fly-fishing lures).

# When she hits enter the page updates and the entry is displayed as:
# "1:  Buy peacock feathers" as an item in the todo list.

# There is still a text box inviting her to add another item. She enters
# "Use peacock feathers to make a fly" (Edith is very methodical).

# The site updates again and now shows both items on the list.

# She wonders if the website remembers her todo items and notices the website has
# generated her a unique url address -- there is some explanatory text to that effect.

# she visits the url and is releived to see the todo list intact.

# Finally she goes to sleep being assured.

if __name__ == '__main__':
    unittest.main()
