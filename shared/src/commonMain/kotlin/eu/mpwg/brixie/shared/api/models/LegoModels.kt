package eu.mpwg.brixie.shared.api.models

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/**
 * LEGO Set data model from Rebrickable API
 */
@Serializable
data class LegoSet(
    @SerialName("set_num") val setNum: String,
    val name: String,
    val year: Int,
    @SerialName("theme_id") val themeId: Int,
    @SerialName("num_parts") val numParts: Int,
    @SerialName("set_img_url") val setImgUrl: String? = null,
    @SerialName("set_url") val setUrl: String? = null,
    @SerialName("last_modified_dt") val lastModifiedDt: String
)

/**
 * LEGO Part data model from Rebrickable API
 */
@Serializable
data class LegoPart(
    @SerialName("part_num") val partNum: String,
    val name: String,
    @SerialName("part_cat_id") val partCatId: Int,
    @SerialName("part_url") val partUrl: String? = null,
    @SerialName("part_img_url") val partImgUrl: String? = null,
    @SerialName("external_ids") val externalIds: Map<String, List<String>>? = null,
    @SerialName("print_of") val printOf: String? = null
)

/**
 * LEGO Theme data model from Rebrickable API
 */
@Serializable
data class LegoTheme(
    val id: Int,
    val name: String,
    @SerialName("parent_id") val parentId: Int? = null
)

/**
 * Color data model from Rebrickable API
 */
@Serializable
data class LegoColor(
    val id: Int,
    val name: String,
    val rgb: String,
    @SerialName("is_trans") val isTrans: Boolean
)