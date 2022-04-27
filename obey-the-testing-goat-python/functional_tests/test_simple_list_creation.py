from .base import FunctionalTest
from selenium import webdriver
from selenium.webdriver.common.keys import Keys

MAX_WAIT = 10

class NewVisitorTest(FunctionalTest):

    def test_can_start_a_list_for_one_user(self):
        # Edith heard about some to-do app online so she visited its homepage.
        self.browser.get(self.live_server_url)

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
        inputbox.send_keys(Keys.ENTER)
        row_text = '1: Buy peacock feathers'
        self.wait_for_row_in_list_table(row_text)

        # There is still a text box inviting her to add another item. She enters
        # "Use peacock feathers to make a fly" (Edith is very methodical).
        inputbox = self.browser.find_element_by_id('id_new_item')
        inputbox.send_keys('Use peacock feathers to make a fly')
        inputbox.send_keys(Keys.ENTER)

        # The site updates again and now shows both items on the list.
        row_text = '1: Buy peacock feathers'
        self.wait_for_row_in_list_table(row_text)
        row_text = '2: Use peacock feathers to make a fly'
        self.wait_for_row_in_list_table(row_text)


# She wonders if the website remembers her todo items and notices the website has
# generated her a unique url address -- there is some explanatory text to that effect.


# she visits the url and is releived to see the todo list intact.

# Finally she goes to sleep being assured.

    def test_multiple_users_can_start_lists_at_different_urls(self):
        # Edith starts a new to-do list
        self.browser.get(self.live_server_url)
        inputbox = self.browser.find_element_by_id('id_new_item')
        inputbox.send_keys('Buy peacock feathers')
        inputbox.send_keys(Keys.ENTER)
        self.wait_for_row_in_list_table('1: Buy peacock feathers')

        # She notices that her list has a unique url
        edith_list_url = self.browser.current_url
        self.assertRegex(edith_list_url, '/lists/.+')

        # Now a new user, Francis, comes along to the site.

        ## We use a new browser session to make sure that no information
        ## of Edith's is coming throught form cookies etc
        self.browser.quit()
        self.browser = webdriver.Firefox()

        # Francis visits the home page, There is no sign of Edith's list
        self.browser.get(self.live_server_url)
        page_text = self.browser.find_element_by_tag_name('body').text
        self.assertNotIn('Buy peacock feathers', page_text)
        self.assertNotIn('make a fly', page_text)

        # Francis starts a new list by entering a new item. He is less
        # interesting than Edith...

        inputbox = self.browser.find_element_by_id('id_new_item')
        inputbox.send_keys('Buy milk')
        inputbox.send_keys(Keys.ENTER)
        self.wait_for_row_in_list_table('1: Buy milk')

        # Francis gets his own unique url
        francis_list_url = self.browser.current_url
        self.assertRegex(francis_list_url, '/lists/.+')
        self.assertNotEqual(francis_list_url, edith_list_url)

        # Again there is no trace of Ediths list
        page_text = self.browser.find_element_by_tag_name('body').text
        self.assertNotIn('make a fly', page_text)
        self.assertIn('1: Buy milk', page_text)

        # Satisfied they both go back to sleep
