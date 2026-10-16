SMODS.Consumable {
  key = 'impatient',
  set = 'Inverted',
  atlas = 'Sculio_Consumables',
  pos = { x = 4, y = 1 },
  unlocked = true,
  discovered = false,
  cost = 3,
  config = { extra = { payout = 5, cap = 75, penalty = 1 } },
  loc_vars = function(self, info_queue, card)
    local extra = self.config.extra
    return { vars = { extra.payout, extra.cap, extra.penalty } }
  end,
  can_use = function(self, card)
    return #G.jokers.cards > 0
  end,
  use = function(self, card, area, copier)
    local extra = self.config.extra
    local total = 0
    for _, j in ipairs(G.jokers.cards) do total = total + j.sell_cost end
    local payout = math.min(extra.payout + total, extra.cap)
    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.4, func = function()
      ease_dollars(payout)
      card:juice_up(0.3, 0.5)
      for _, j in ipairs(G.jokers.cards) do
        if not j.gone then
          j.sell_cost = j.sell_cost - extra.penalty
          j:juice_up(0.3, 0.5)
        end
      end
      return true
    end }))
    delay(1.0)
  end,
}
