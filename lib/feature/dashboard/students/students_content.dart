import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ufcat_ru_check/data/student/student.dart';
import 'package:ufcat_ru_check/di/service_locator.dart';
import 'package:ufcat_ru_check/feature/dashboard/students/students_bloc.dart';
import 'package:ufcat_ru_check/feature/dashboard/students/students_state.dart';
import 'package:ufcat_ru_check/ui/extensions/level_extensions.dart';

class StudentsContent extends StatelessWidget {
  const StudentsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServiceLocator.get<StudentsBloc>()..loadStudents(),
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<StudentsBloc, StudentsState>(
            builder: (context, data) {
              if (data.students.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: Text('Nenhum estudante importado para o sitema'),
                      ),
                      FilledButton.icon(
                        onPressed: () => {},
                        style: const ButtonStyle(),
                        icon: const Icon(MdiIcons.plus),
                        label: const Text('Importar do SIGAA'),
                      ),
                    ],
                  ),
                );
              }
              return _buildSheet(data.students);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSheet(List<Student> students) {
    if (students.isEmpty) {
      return Container();
    }

    return SingleChildScrollView(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Matrícula')),
          DataColumn(label: Text('Nome completo')),
          DataColumn(label: Text('CPF')),
          DataColumn(label: Text('Nível')),
          DataColumn(label: Text('Matriculado')),
          DataColumn(label: Text('Ultima atualização')),
        ],
        rows: students
            .map((student) => DataRow(cells: [
                  DataCell(Text(student.id)),
                  DataCell(Text(student.name)),
                  DataCell(Text(student.document)),
                  DataCell(Text(student.level.label)),
                  DataCell(Text(student.regular ? 'Sim' : 'Não')),
                  DataCell(Text(DateFormat.yMd().format(student.updatedAt))),
                ]))
            .toList(),
      ),
    );
  }
}
