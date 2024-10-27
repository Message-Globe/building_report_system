import '../../authentication/domain/building.dart';
import '../domain/report.dart';

// Definizione degli edifici
final Building schoolBuilding = Building(id: '1', name: 'Scuola Media');
final Building hospitalBuilding = Building(id: '2', name: 'Ospedale');

// Lista dei report di test
final kTestReports = <Report>[
  Report(
    id: '1',
    createdBy: "1",
    assignedTo: "2",
    building: schoolBuilding,
    buildingSpot: "Aula 3",
    priority: PriorityLevel.urgent,
    title: 'Interruttore luce rotto',
    description:
        "L'interruttore della luce presenta dei problemi nei cavi in prossimità di ...",
    status: ReportStatus.assigned,
    createdAt: DateTime.parse('2024-10-08'),
    updatedAt: DateTime.parse('2024-10-08'),
    photoUrls: [
      "https://static.italiaoggi.it/content_upload/img/2608/75/2608751/dannimaltempo-631775.jpg",
      "https://media-assets.wired.it/photos/646b383a14e3921f4e7c7c3b/16:9/w_2560%2Cc_limit/1256998159",
    ],
    maintenanceDescription: '',
    maintenancePhotoUrls: [],
  ),
  Report(
    id: '2',
    createdBy: "1",
    assignedTo: "",
    building: hospitalBuilding,
    buildingSpot: "Sala verde - Reparto Chirurgia",
    priority: PriorityLevel.normal,
    title: 'Sistema di raffreddamento rotto',
    description: "Il sistema di raffreddamento ha iniziato a funzionare solo quando ...",
    status: ReportStatus.opened,
    createdAt: DateTime.parse('2024-10-07'),
    updatedAt: DateTime.parse('2024-10-07'),
    photoUrls: [
      "https://static.italiaoggi.it/content_upload/img/2608/75/2608751/dannimaltempo-631775.jpg",
      "https://media-assets.wired.it/photos/646b383a14e3921f4e7c7c3b/16:9/w_2560%2Cc_limit/1256998159",
    ],
    maintenanceDescription: '',
    maintenancePhotoUrls: [],
  ),
  Report(
    id: '3',
    createdBy: "1",
    assignedTo: "2",
    building: schoolBuilding,
    buildingSpot: "Aula 5",
    priority: PriorityLevel.urgent,
    title: 'Porta da riparare',
    description: "I perni della porta sono usciti leggermente fuori asse e ...",
    status: ReportStatus.completed,
    createdAt: DateTime.parse('2024-09-15'),
    updatedAt: DateTime.parse('2024-09-15'),
    photoUrls: [
      "https://static.italiaoggi.it/content_upload/img/2608/75/2608751/dannimaltempo-631775.jpg",
      "https://media-assets.wired.it/photos/646b383a14e3921f4e7c7c3b/16:9/w_2560%2Cc_limit/1256998159",
    ],
    maintenanceDescription: '',
    maintenancePhotoUrls: [],
  ),
  Report(
    id: '4',
    createdBy: "1",
    assignedTo: "2",
    building: hospitalBuilding,
    buildingSpot: "Corridoio ingresso",
    priority: PriorityLevel.normal,
    title: 'Finestra rotta',
    description: "La finestra grande, quella a due ante, presenta una crepa in ...",
    status: ReportStatus.deleted,
    createdAt: DateTime.parse('2024-08-01'),
    updatedAt: DateTime.parse('2024-08-01'),
    photoUrls: [
      "https://static.italiaoggi.it/content_upload/img/2608/75/2608751/dannimaltempo-631775.jpg",
      "https://media-assets.wired.it/photos/646b383a14e3921f4e7c7c3b/16:9/w_2560%2Cc_limit/1256998159",
    ],
    maintenanceDescription: '',
    maintenancePhotoUrls: [],
  ),
  Report(
    id: '5',
    createdBy: "1",
    assignedTo: "2",
    building: schoolBuilding,
    buildingSpot: "Scale piano terra - primo piano",
    priority: PriorityLevel.normal,
    title: 'Corrimano pericoloso',
    description:
        "Il corrimano delle scale ha un punto in cui ci sono delle irregolarità e potrebbe essere ...",
    status: ReportStatus.completed,
    createdAt: DateTime.parse('2024-08-01'),
    updatedAt: DateTime.parse('2024-08-01'),
    photoUrls: [
      "https://static.italiaoggi.it/content_upload/img/2608/75/2608751/dannimaltempo-631775.jpg",
      "https://media-assets.wired.it/photos/646b383a14e3921f4e7c7c3b/16:9/w_2560%2Cc_limit/1256998159",
    ],
    maintenanceDescription: '',
    maintenancePhotoUrls: [],
  ),
];
