module WithPerformanceBar
  extend ActiveSupport::Concern

  included do
    include Peek::Rblineprof::CustomControllerHelpers
    alias_method :performance_bar_enabled?, :peek_enabled?
    helper_method :performance_bar_enabled?
  end

  def peek_enabled?
    return false unless Gitlab::PerformanceBar.enabled?(current_user)

    if RequestStore.active?
      RequestStore.fetch(:peek_enabled) { cookies[:perf_bar_enabled].present? }
    else
      cookies[:perf_bar_enabled].present?
    end
  end
end
