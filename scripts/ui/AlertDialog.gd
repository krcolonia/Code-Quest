extends CanvasLayer

# ? Default Variables
var title_default: String = "PopupTitle"
var message_default: String = "PopupMessage"

var button1_default_name: String = "Close"
var button2_default_name: String = "Confirm"

var check_message_default: String = "[center]I agree with the [u]Privacy Policy[/u] of the app"
var scroll_message_default: String = "
[center]Effective Date: 06-05-2024[/center]

[b]1. Introduction[/b]
[indent]Welcome to Code Quest, a game-based learning app designed to teach Python programming for Software Development. We value the privacy of our users, so through this Privacy Policy, we will explain how we collect, use, disclose, and safeguard your information when you use our application[/indent]

[b]2. Information We Collect[/b]
[ol type=a]
 Personal Information
[ul] Account Information: When you create an account, we collect your username, email address, and password
 Profile Information: You may choose to provide additional information such as a profile bio.
 Full Name: We collect your full name for certification purposes. This allows us to issue certificates for each game chapter you complete.
[/ul]
 Usage Data
[ul] Progress Tracking: We collect data on your game progress, including levels completed, scores, and achievements.
 Leaderboard Data: We track and display your scores on leaderboards.[/ul]
[/ol]

[b]3. How We Use Your Information[/b]
[indent]We use the information we collect for the following purposes:[/indent]
[ul] To create and manage your account
 To track your learning progress and game achievements
 To display your scores on leaderboards
 To issue certificates upon completion of game chapters
 To improve our game and learning experience
 To communicate with you, our users, about updates, promotions, and support.[/ul]

[b]4. Information Storing and Disclosure[/b]
[indent]We do not share your personal information with the exception of the following circumstances:[/indent]
[ul] With your Consent: We may share your information if you give explicit consent to do so.
 Service Providers: We may share your information with third-party service providers who assist us in operating the game and providing services to you. These providers are bound by contractual obligations to keep your information confidential and secure.
 Legal Requirements: We may disclose your information if required to do so by law or in response to valid requests by public authorities (e.g. a court or government agency)[/ul]

[b]5. Data Security[/b]
[indent]We implement appropriate technical and organizational measures to protect your personal information from unauthorized access, use, or disclosure. However, no security system is impenetrable, and we cannot guarantee the absolute security of your data.[/indent]

[b]6. Your Rights[/b]
[indent]You have the following rights regarding your personal information:[/indent]
[ul] Access: You can request access to the personal information we hold about you.
 Correction: You can request that we correct any inaccurate or incomplete information.
 Deletion: you can request that we delete your account and personal information.[/ul]

[b]7. Changes to this Privacy Policy[/b]
[indent]We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy periodically for any changes.[/indent]

[b]8. Contact Us[/b]
[indent]If you have any questions about this Privacy Policy, please contact us at:

codequest.kd@gmail.com[/indent]

[b]9. Consent[/b]
[indent]By using Code Quest, you consent to the terms of this Privacy Policy[/indent]
"

# ? Node for AlertDialog Margin
@onready var margin: MarginContainer = $PopupMargin

# ? Node for AlertDialog title
@onready var title: Label = $PopupMargin/Panel/ContentMargin/ContentVBox/PopupTitle

# ? Node for AlertDialog Message
@onready var message: Label = $PopupMargin/Panel/ContentMargin/ContentVBox/Panel/MessageMargin/PopupMessage

# ? Node for Scroll Container and Scroll Message, mainly used for the Privacy Policy
@onready var scroll_container: ScrollContainer = $PopupMargin/Panel/ContentMargin/ContentVBox/Panel/MessageMargin/ScrollContainer
@onready var scroll_message: RichTextLabel = $PopupMargin/Panel/ContentMargin/ContentVBox/Panel/MessageMargin/ScrollContainer/Control/PopupMessage

# ? Node for checkbox
@onready var check_container = $PopupMargin/Panel/ContentMargin/ContentVBox/HBoxContainer
@onready var check_input = $PopupMargin/Panel/ContentMargin/ContentVBox/HBoxContainer/PrivacyCheck
@onready var check_message = $PopupMargin/Panel/ContentMargin/ContentVBox/HBoxContainer/RichTextLabel


# ? Nodes for AlertDialog Buttons
@onready var button1: Button = $PopupMargin/Panel/ContentMargin/ContentVBox/InputHBox/PopupButton1
@onready var button2: Button = $PopupMargin/Panel/ContentMargin/ContentVBox/InputHBox/PopupButton2

func _ready() -> void:
	close()

func close() -> void:
	# ? Hides the alert by default upon loading
	self.hide()

	# ? Sets the default text inside the buttons
	reset_button1_name()
	reset_button2_name()

	show_message()

	# ? Hides the check box and sets the checkbox message by its default value
	hide_check()
	reset_check_message()

	# ? Sets its text by its default value
	reset_scroll_message()

# ? Button 1 Functions
func set_button1_name(button_name: String) -> void:
	button1.text = button_name

func show_button1() -> void:
	button1.show()

func hide_button1() -> void:
	button1.hide()

func reset_button1_name() -> void:
	button1.text = button1_default_name

# ? Button 2 Functions
func set_button2_name(button_name: String) -> void:
	button2.text = button_name

func show_button2() -> void:
	button2.show()

func hide_button2() -> void:
	button2.hide()

func reset_button2_name() -> void:
	button2.text = button2_default_name

# ? Popup Title Functions
func set_title(title_var: String) -> void:
	title.text = title_var

# ? Popup Message Functions
func set_message(message_var: String) -> void:
	message.text = message_var

func show_message() -> void:
	message.show()
	scroll_container.hide()

# ? Popup Scroll Message Functions
func set_scroll_message(message_var: String) -> void:
	scroll_message.text = message_var

func show_scroll_message() -> void:
	scroll_container.show()
	message.hide()

func reset_scroll_message() -> void:
	scroll_message.text = scroll_message_default

# ? Checkmark Input Functions
func show_check() -> void:
	check_container.show()
	
func hide_check() -> void:
	check_container.hide()

func set_check_message(message_var: String) -> void:
	check_message.text = message_var

func reset_check_message() -> void:
	check_message.text = check_message_default

func set_margin(top: int, bottom: int) -> void:
	margin.add_theme_constant_override("margin_top", top)
	margin.add_theme_constant_override("margin_bottom", bottom)

func reset_margin() -> void:
	margin.add_theme_constant_override("amrgin_top", 45)
	margin.add_theme_constant_override("amrgin_bottom", 45)
	margin.add_theme_constant_override("amrgin_left", 45)
	margin.add_theme_constant_override("amrgin_right", 45)