class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week #自分のメモ Issue2 get_weekメソッドを
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan) #issue4 params.requireをcalendarsからplanへ
  end

  def get_week #自分のメモ Isseu2
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例) 今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      plan = plans.map do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end

      wday_num = Date.today.wday #添字となる数値を得る
      #もしもwday_numが7以上であれば、7を引く
      if wday_num >= 7 #条件式を記述
        wday_num = wday_num - 7
      end

      days = { month: (@todays_date + x).month, date: (@todays_date+x).day, plans: today_plans, wday: wdays[wday_num + x]} #wdaysから値を取り出し、日付に合わせて曜日を
      days = { month: (@todays_date + x).month, date: (@todays_date+x).day, plans: today_plans} #自分のメモ Issue1 キーをシンボル記法へ修正

      @week_days.push(days)
    end

  end
end