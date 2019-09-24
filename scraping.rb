require 'selenium-webdriver'

def lambda_handler(event:, context:)
    d = Selenium::WebDriver.for :chrome
    d.get("https://yoyakunomado.com/koganei/sp/index.jsp")

    # 空き状況確認
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)
         d.find_element(:xpath, '/html/body/div[1]/div[2]/ul/li[1]/a').click
         sleep 3

    # 体育施設
    wait.until {d.find_element(:xpath, '/html/body/div[3]/div[2]/ul/li[1]/a').displayed?}
        d.find_element(:xpath, '/html/body/div[3]/div[2]/ul/li[1]/a').click
        sleep 3

    # 上水公園運動施設
    reserve = []
    wait.until {d.find_element(:xpath, '/html/body/div[3]/div[2]/ul/li[2]/a').displayed?}
        name = d.find_element(:xpath, '/html/body/div[3]/div[2]/ul/li[2]/a').text
        reserve.push(name)
        d.find_element(:xpath, '/html/body/div[3]/div[2]/ul/li[2]/a').click
        sleep 3

    # Aコート
    wait.until {d.find_element(:xpath, '/html/body/div[3]/div[2]/ul/li[3]/a').displayed?}
        coat = d.find_element(:xpath, '/html/body/div[3]/div[2]/ul/li[3]/a').text
        reserve.push(coat)
        d.find_element(:xpath, '/html/body/div[3]/div[2]/ul/li[3]/a').click
        sleep 3

            for weeks in 2..7 do
                d.find_element(:xpath, "/html/body/div[3]/div[2]/ul/li[#{weeks}]/a").click
                sleep 3
                    for days in 2..7 do
                        available_days = d.find_element(:xpath, "/html/body/div[3]/div[2]/ul/li[#{days}]/a").text
                        if available_days.include?('○') then
                            reserve.push(available_days)
                            d.find_element(:xpath, "/html/body/div[3]/div[2]/ul/li[#{days}]/a").click
                            sleep 3
                                for date_time in 2..7 do
                                    begin
                                      available_date_time = d.find_element(:xpath, "/html/body/div[3]/div[2]/ul/li[#{date_time}]").text
                                    rescue => error
                                      puts error
                                      available_date_time = "✕"
                                    end

                                    # その日の空いてる時間帯だけ配列に格納
                                    if available_date_time.include?('○') then
                                        reserve.push(available_date_time)
                                        pp reserve
                                    end
                                end
                            sleep 3
                            d.navigate.back
                            sleep 3
                        end
                    end
                sleep 3
                d.navigate.back
                sleep 3
            end
            pp reserve
        sleep 3
        d.navigate.back
        sleep 3

    # Bコート
    # wait.until {d.find_element(:xpath, '/html/body/div[3]/div[2]/ul/li[4]/a').displayed?}
    #        puts d.find_element(:xpath, '/html/body/div[3]/div[2]/ul/li[4]/a').text
    #             d.find_element(:xpath, '/html/body/div[3]/div[2]/ul/li[4]/a').click
end