//
//  NewsFeedMapper.swift
//  VK
//
//  Created by Tigran Garibyan on 10.10.2026.
//

import Foundation

enum NewsFeedMapper {

    private static let preferredPhotoWidth = 600

    static func makePage(from dto: NewsFeedResponseDTO) -> NewsPage {
        let profiles = makeProfilesMap(dto.profiles)
        let groups = makeGroupsMap(dto.groups)

        let items: [NewsItem] = dto.items.compactMap { item in
            guard let author = makeAuthor(
                sourceId: item.sourceId,
                profiles: profiles,
                groups: groups
            ) else {
                return nil
            }

            return NewsItem(
                id: item.postId ?? item.sourceId,
                author: author,
                date: Date(timeIntervalSince1970: TimeInterval(item.date)),
                text: item.text ?? "",
                attachments: makeAttachments(item.attachments),
                likes: Likes(
                    count: item.likes?.count ?? 0,
                    userLikes: item.likes?.userLikes == 1
                ),
                comments: Comments(count: item.comments?.count ?? 0),
                reposts: Reposts(
                    count: item.reposts?.count ?? 0,
                    userReposted: item.reposts?.userReposted == 1
                )
            )
        }

        return NewsPage(
            items: items,
            nextFrom: dto.nextFrom
        )
    }
}

private extension NewsFeedMapper {
    static func makeProfilesMap(_ profiles: [ProfileDTO]?) -> [Int: ProfileDTO] {
        Dictionary(
            (profiles ?? []).map { ($0.id, $0) },
            uniquingKeysWith: { first, _ in first }
        )
    }

    static func makeGroupsMap(_ groups: [GroupDTO]?) -> [Int: GroupDTO] {
        Dictionary(
            (groups ?? []).map { ($0.id, $0) },
            uniquingKeysWith: { first, _ in first }
        )
    }

    static func makeAuthor(
        sourceId: Int,
        profiles: [Int: ProfileDTO],
        groups: [Int: GroupDTO]
    ) -> Profile? {
        if sourceId >= 0 {
            guard let profile = profiles[sourceId] else { return nil }
            let name = [profile.firstName, profile.lastName]
                .compactMap { $0 }
                .joined(separator: " ")
            return Profile(
                id: profile.id,
                name: name,
                screenName: profile.screenName,
                avatarURL: profile.photo100.flatMap(URL.init(string:)),
                isGroup: false
            )
        } else {
            let groupId = abs(sourceId)
            guard let group = groups[groupId] else { return nil }
            return Profile(
                id: group.id,
                name: group.name ?? "",
                screenName: group.screenName,
                avatarURL: (group.photo100 ?? group.photo200).flatMap(URL.init(string:)),
                isGroup: true
            )
        }
    }

    static func makeAttachments(_ attachments: [AttachmentDTO]?) -> [Attachment] {
        (attachments ?? []).compactMap { attachment in
            guard attachment.type == "photo",
                  let photoDTO = attachment.photo,
                  let photo = makePhoto(photoDTO) else { return nil }
            return .photo(photo)
        }
    }

    static func makePhoto(_ dto: PhotoDTO) -> Photo? {
        let size = bestSize(from: dto.sizes ?? [])
        let width = size?.width ?? dto.width ?? 0
        let height = size?.height ?? dto.height ?? 0
        guard width > 0, height > 0 else { return nil }

        return Photo(
            url: size?.url.flatMap(URL.init(string:)),
            width: width,
            height: height
        )
    }

    static func bestSize(from sizes: [PhotoSizeDTO]) -> PhotoSizeDTO? {
        let withURL = sizes.filter { $0.url != nil }
        let bigEnough = withURL.filter { ($0.width ?? 0) >= preferredPhotoWidth }

        if let smallestEnough = bigEnough.min(by: { ($0.width ?? 0) < ($1.width ?? 0) }) {
            return smallestEnough
        }
        return withURL.max(by: { ($0.width ?? 0) < ($1.width ?? 0) })
    }
}
