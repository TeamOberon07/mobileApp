//enum contente ogni stato possibile per un ordine, semplifica molto la leggibilitĂ  del codice

enum OrderState {
  Created,
  Shipped,
  Confirmed,
  Deleted,
  Asked_Refund,
  Refunded,
}
