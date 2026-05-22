import '../models/recommendation_model.dart';

/// Recomendaciones de autocuidado adaptadas al contexto chileno.
/// 
/// IMPORTANTE — Lógica de condición:
/// - 'diabetes'     → solo para personas con diabetes
/// - 'hypertension' → solo para personas con hipertensión  
/// - 'both'         → diseñado específicamente para quienes
///                    tienen ambas condiciones simultáneamente.
///                    NO es una mezcla — es contenido balanceado
///                    que considera la interacción entre ambas.
///
/// Fuente: guías generales de autocuidado para enfermedades crónicas.
/// No reemplaza indicaciones médicas individuales.
class RecommendationsData {

  // ── DIABETES ───────────────────────────────────────────────
  static final List<RecommendationModel> _diabetes = [
    RecommendationModel(
      id: 'r_d_1',
      title: 'Prefiere el arroz integral',
      description:
          'El arroz blanco sube la glucosa rápidamente. '
          'El arroz integral libera energía de forma más gradual. '
          'Si no lo consigues, reduce la porción a media taza.',
      category: 'alimentacion',
      condition: 'diabetes',
    ),
    RecommendationModel(
      id: 'r_d_2',
      title: 'Evita las bebidas dulces',
      description:
          'Las bebidas con azúcar, jugos envasados y néctares '
          'elevan la glucosa muy rápido. '
          'Prefiere agua, agua con limón o infusiones sin azúcar.',
      category: 'alimentacion',
      condition: 'diabetes',
    ),
    RecommendationModel(
      id: 'r_d_3',
      title: 'Come a horarios regulares',
      description:
          'Saltarse comidas puede causar bajones de glucosa. '
          'Intenta comer cada 4-5 horas, '
          'incluyendo colaciones pequeñas como frutas o frutos secos.',
      category: 'alimentacion',
      condition: 'diabetes',
    ),
    RecommendationModel(
      id: 'r_d_4',
      title: 'Camina después de comer',
      description:
          'Una caminata de 15-20 minutos después del almuerzo '
          'ayuda a tu cuerpo a usar la glucosa de forma más eficiente. '
          'No necesitas ir al gimnasio — basta con salir a la cuadra.',
      category: 'ejercicio',
      condition: 'diabetes',
    ),
    RecommendationModel(
      id: 'r_d_5',
      title: 'Ejercicio moderado y constante',
      description:
          '30 minutos de caminata, bicicleta o baile '
          'cinco días a la semana es suficiente y muy efectivo. '
          'La constancia importa más que la intensidad.',
      category: 'ejercicio',
      condition: 'diabetes',
    ),
    RecommendationModel(
      id: 'r_d_6',
      title: 'Hidrátate bien durante el día',
      description:
          'La deshidratación puede elevar la concentración de glucosa. '
          'Intenta tomar al menos 8 vasos de agua al día, '
          'distribuidos a lo largo del día.',
      category: 'hidratacion',
      condition: 'diabetes',
    ),
    RecommendationModel(
      id: 'r_d_7',
      title: 'El estrés afecta tu glucosa',
      description:
          'Cuando estás bajo estrés, el cuerpo libera hormonas '
          'que suben la glucosa. Practicar respiración profunda, '
          'escuchar música o caminar ayuda a manejarlo.',
      category: 'bienestar',
      condition: 'diabetes',
    ),
    RecommendationModel(
      id: 'r_d_8',
      title: 'El sueño también importa',
      description:
          'Dormir menos de 6 horas afecta la sensibilidad a la insulina. '
          'Intenta mantener horarios regulares de sueño '
          'y evita pantallas antes de dormir.',
      category: 'bienestar',
      condition: 'diabetes',
    ),
  ];

  // ── HIPERTENSIÓN ───────────────────────────────────────────
  static final List<RecommendationModel> _hypertension = [
    RecommendationModel(
      id: 'r_h_1',
      title: 'Reduce la sal gradualmente',
      description:
          'No necesitas eliminar la sal de golpe. '
          'Empieza por no agregar sal extra en la mesa '
          'y usa limón, ajo o hierbas para dar sabor.',
      category: 'alimentacion',
      condition: 'hypertension',
    ),
    RecommendationModel(
      id: 'r_h_2',
      title: 'Cuidado con los alimentos procesados',
      description:
          'Embutidos, sopas en sobre, salsas envasadas y snacks '
          'tienen mucho sodio oculto. '
          'Elige opciones con menos de 400mg de sodio por porción.',
      category: 'alimentacion',
      condition: 'hypertension',
    ),
    RecommendationModel(
      id: 'r_h_3',
      title: 'Más frutas y verduras en tu día',
      description:
          'El potasio en frutas y verduras ayuda a contrarrestar '
          'el efecto del sodio. '
          'Plátano, espinaca, tomate y naranja son opciones accesibles.',
      category: 'alimentacion',
      condition: 'hypertension',
    ),
    RecommendationModel(
      id: 'r_h_4',
      title: 'Caminata diaria suave',
      description:
          'El ejercicio aeróbico suave es uno de los mejores aliados '
          'contra la hipertensión. '
          '30 minutos de caminata al día puede bajar la presión '
          'tanto como algunos medicamentos.',
      category: 'ejercicio',
      condition: 'hypertension',
    ),
    RecommendationModel(
      id: 'r_h_5',
      title: 'Evita esfuerzos físicos bruscos',
      description:
          'Levantar objetos muy pesados o ejercicio muy intenso de golpe '
          'puede subir la presión momentáneamente. '
          'Prefiere actividad moderada y progresiva.',
      category: 'ejercicio',
      condition: 'hypertension',
    ),
    RecommendationModel(
      id: 'r_h_6',
      title: 'Hidrátate regularmente',
      description:
          'Tomar agua regularmente es importante para la presión arterial. '
          'En general, 6-8 vasos al día es adecuado. '
          'Consulta a tu médico si tienes indicación especial de líquidos.',
      category: 'hidratacion',
      condition: 'hypertension',
    ),
    RecommendationModel(
      id: 'r_h_7',
      title: 'Practica respiración profunda',
      description:
          'Inhala por la nariz 4 segundos, mantén 4 segundos, '
          'exhala por la boca 6 segundos. '
          'Repetir 5 veces puede reducir la presión momentáneamente '
          'y ayuda a manejar el estrés del día.',
      category: 'bienestar',
      condition: 'hypertension',
    ),
    RecommendationModel(
      id: 'r_h_8',
      title: 'El sueño regula tu presión',
      description:
          'Durante el sueño la presión arterial baja naturalmente. '
          'Dormir mal interrumpe ese proceso. '
          'Intenta acostarte a la misma hora y dormir al menos 7 horas.',
      category: 'bienestar',
      condition: 'hypertension',
    ),
  ];

  // ── AMBAS CONDICIONES ──────────────────────────────────────
  // Contenido redactado específicamente para personas con
  // diabetes E hipertensión simultáneamente.
  // Busca el balance entre ambas condiciones, evitando
  // recomendaciones que beneficien a una y perjudiquen a la otra.
  static final List<RecommendationModel> _both = [
    RecommendationModel(
      id: 'r_b_1',
      title: 'Una alimentación que cuida las dos',
      description:
          'Tu dieta ideal combina bajo índice glucémico (para la glucosa) '
          'y bajo sodio (para la presión). '
          'Verduras sin almidón, legumbres, pescado y aceite de oliva '
          'son excelentes para ambas condiciones.',
      category: 'alimentacion',
      condition: 'both',
    ),
    RecommendationModel(
      id: 'r_b_2',
      title: 'Porciones moderadas y horarios regulares',
      description:
          'Comer porciones moderadas a horarios fijos beneficia '
          'tanto la glucosa como la presión arterial. '
          'Evita saltarte comidas y evita comer en exceso de una vez.',
      category: 'alimentacion',
      condition: 'both',
    ),
    RecommendationModel(
      id: 'r_b_3',
      title: 'Frutas sí, pero con criterio',
      description:
          'Las frutas son buenas para la presión (por su potasio), '
          'pero algunas suben la glucosa rápido. '
          'Prefiere manzana, pera, naranja o frutillas '
          'en lugar de uva, mango o plátano en grandes cantidades.',
      category: 'alimentacion',
      condition: 'both',
    ),
    RecommendationModel(
      id: 'r_b_4',
      title: 'Reduce sal Y azúcar a la vez',
      description:
          'No necesitas hacerlo de golpe. '
          'Esta semana reduce el azúcar en el té. '
          'La próxima, usa menos sal en las ensaladas. '
          'Los cambios graduales son más sostenibles.',
      category: 'alimentacion',
      condition: 'both',
    ),
    RecommendationModel(
      id: 'r_b_5',
      title: 'Ejercicio suave: aliado de ambas',
      description:
          'La caminata de 30 minutos a ritmo moderado '
          'mejora la sensibilidad a la insulina Y baja la presión arterial. '
          'Es el ejercicio más recomendado cuando se tienen ambas condiciones.',
      category: 'ejercicio',
      condition: 'both',
    ),
    RecommendationModel(
      id: 'r_b_6',
      title: 'Evita el ejercicio intenso sin preparación',
      description:
          'Con ambas condiciones, el ejercicio muy intenso de golpe '
          'puede ser contraproducente. '
          'Empieza siempre con 5 minutos de caminata suave '
          'antes de aumentar el ritmo.',
      category: 'ejercicio',
      condition: 'both',
    ),
    RecommendationModel(
      id: 'r_b_7',
      title: 'Hidratación equilibrada',
      description:
          'Con diabetes necesitas buena hidratación. '
          'Con hipertensión, algunos médicos indican moderar líquidos. '
          'El balance general es 6-8 vasos de agua al día, '
          'salvo que tu médico indique otra cosa.',
      category: 'hidratacion',
      condition: 'both',
    ),
    RecommendationModel(
      id: 'r_b_8',
      title: 'El estrés afecta las dos condiciones',
      description:
          'El estrés crónico sube tanto la glucosa como la presión arterial. '
          'Dedica al menos 10 minutos al día a algo que te relaje: '
          'música, lectura, respiración profunda o una caminata tranquila.',
      category: 'bienestar',
      condition: 'both',
    ),
    RecommendationModel(
      id: 'r_b_9',
      title: 'Dormir bien es doble beneficio',
      description:
          'El sueño de calidad mejora la sensibilidad a la insulina '
          'y permite que la presión arterial baje naturalmente durante la noche. '
          'Intenta dormir 7-8 horas en horarios regulares.',
      category: 'bienestar',
      condition: 'both',
    ),
    RecommendationModel(
      id: 'r_b_10',
      title: 'El alcohol afecta las dos',
      description:
          'El alcohol puede subir la glucosa y elevar la presión arterial. '
          'Si lo consumes, hazlo ocasionalmente y en cantidades mínimas. '
          'Nunca con el estómago vacío si tienes diabetes.',
      category: 'bienestar',
      condition: 'both',
    ),
  ];

  /// Retorna recomendaciones según la condición del usuario.
  /// 'both' retorna contenido específico para ambas condiciones,
  /// NO una mezcla de los otros dos grupos.
  static List<RecommendationModel> forCondition(String condition) {
    switch (condition) {
      case 'diabetes':
        return _diabetes;
      case 'hypertension':
        return _hypertension;
      case 'both':
        return _both;
      default:
        return _both;
    }
  }

  /// Retorna las categorías únicas presentes para una condición
  static List<String> categoriesFor(String condition) {
    final recs = forCondition(condition);
    return recs.map((r) => r.category).toSet().toList();
  }
}