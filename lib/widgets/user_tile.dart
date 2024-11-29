import 'package:flatwork/data/data.dart';
import 'package:flatwork/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    required this.user,
    this.isSelect = false,
    this.onDelete,
  });

  final User user;
  final bool? isSelect;
  final Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    // decoration: BoxDecoration(
    //   color: Colors.amber.shade50,
    //   borderRadius: BorderRadius.circular(10),
    // ),
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${user.firstName} ${user.lastName}",
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const Gap(5),
              Text(
                user.email,
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        !isSelect!? InkWell(
          onTap: () async {
            await onDelete!();
          },
          child: const Icon(
            Icons.delete_outline,
            color: Colors.redAccent,
            size: 25,
          ),
        ):
        const Gap(0),
      ],
    );
  }
}
