# a simple ruby tool for stealing cookie
require 'watir'
require 'webdrivers'
require_relative 'decipher'

$user_login          = ENV['USER_LOGIN']
$user_password       = ENV['USER_PASSWORD']
$user_main_url = "" #your url here

$browser = nil

def browser_init
    $browser = Watir::Browser.start $user_main_url, :firefox, headless:  true
end

def run_browser
    unless $browser
        browser_init()
    end
    unless $browser.exists?
        browser_init()
    end
end

def close_browser
    $browser_init()
end

def login
    login_link = $browser.link text: "Log In"
    if login_link.exists?
        login_link.click
        $browser.text_field(id: 'user_login').set $user_login
        $browser.button(id: 'user_password').set $user_password
        $browser.button(name: 'commit').click
    end
end

def timer
    #return the time should sleep
    sleep = 0
    timer = $browser.div(id: 'timer')
    if timer.exists?
        timer_value = timer.child.text
        next_cookie_time = parser_countdown(timer_value)
        wait_extra = rand(30..120)
        puts "Next cookie will be in #{next_cookie_time}seconds but you want to wait till #{wait_extra}"
        sleep = next_cookie_time + wait_extra
    end
    return sleep
end

def solve 
    solve = $browser.element(:xpath => "//form[@id='new_theft']//strong")
    if solve.exists?
        decipher = Decipher.new(solve.text)
        $browser.text_field(id: 'theft_answer').set decipher.execute()
        puts "Solving math: '#{solve.text}' expression is '#{decipher.expression}' and result is '#{decipher.result}'"
        $browser.element(id: 'new_theft').click()
    end
end

def parser_countdown(text)
    #countdown timer in format mm:ss
    match = text.match /(\d{2}):(\d{2})/
    min = match[1].to_i
    sec = match[2].to_i

    total = min*60+sec

    return total
end

run_browser()
login()
while(true)
    sleep = timer()
    if sleep > 0
        close_browser()
        sleep(sleep)
        run_browser()
    end
    login()
    solve()
end