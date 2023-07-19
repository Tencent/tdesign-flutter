/*! *****************************************************************************
Copyright (c) 2023 Tencent, Inc. All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
***************************************************************************** */

/// <reference path="./lib.wx.phys3D.d.ts" />
declare type HTMLCanvasElement = any
declare type ImageData = any
declare type HTMLImageElement = any

declare module 'XrFrame' {
    import * as xrFrameSystem from 'XrFrame/xrFrameSystem'
    import { IComponentSchema, IEntityComponents } from 'XrFrame/xrFrameSystem'

    export {
        IComponentSchema,
        IEntityComponents,
        IEffectAsset,
        IRenderStates,
        ISubMesh,
        IVideoTextureOptions,
        IRenderTarget,
        IRenderTextureOptions,
        IGLTFModelOptions,
        IEnvDataOptions,
        IKeyframeAnimationData,
        IKeyframeAnimationInfo,
        IKeyframeAnimationOptions,
        IAtlasOptions,
        IAtlasCreationOptions,
        IPostProcessOptions,
        IDataValueHandler,
        ITextureWrapper,
        ITextureOptions,
        IEngineSettings,
        IHandle,
        IVertexLayoutOptions,
        IVertexDataDescriptorOptions,
        IUniformDescriptorOptions,
        IImage,
        IRealDownloader,
        IDownloader,
        IFontSetting,
        IFeatures,
        IRect,
        IViewAction,
        IView,
        IAttachment,
        IRenderPassDescriptor,
        IGlyphInfo,
        IEventBridge,
        INativeMap,
        ILongIntNativeMap,
        ITransformData,
        IAssetsData,
        ICameraData,
        IGLTFData,
        ILightData,
        IAssetMaterialData,
        IMeshData,
        ITextData,
        IAssetRenderTextureData,
        IEnvData,
        IAnimatorData,
        IAnimationPlayOptions,
        IAnimatorAutoPlay,
        ICameraOrbitControlData,
        IARTrackerData,
        IARTrackerRawData,
        IShapeData,
        ISphereShapeData,
        IMeshShapeData,
        ICapsuleShapeData,
        ICubeShapeData,
        IShapeGizmosData,
        IAssetPostProcessData,
        IParticleData,
        IAssetsSystemData,
        INodeSystemData,
        ITickSystemData,
        IAnimationSystemData,
        IVideoSystemData,
        IRenderSystemData,
        IPhysicsSystemData,
        IShapeDragEvent,
        IShapeTouchEvent,
        IARSystemData,
        IARRawData,
        IShareSystemData,
        IShareCaptureOptions,
        IGizmoSystemData,
        ILoaderOptionsSchema,
        ITextureLoaderOptions,
        IImageLoaderOptions,
        ICubeTextureLoaderOptions,
        IVideoTextureLoaderOptions,
        IEnvDataLoaderOptions,
        IGLTFLoaderOptions,
        IKeyframeLoaderOptions,
        IRawLoaderOptions,
        IAtlasLoaderOptions,
        TEventCallback,
        TDirection,
        Texture,
        UniformDescriptor,
        UniformBlock,
        VertexLayout,
        TCameraBackground,
        TTrackMode,
        EVertexFormat,
        EVertexStep,
        EIndexType,
        ETextureType,
        ETextureFormat,
        EWrapMode,
        EFilterMode,
        EUniformType,
        ECullMode,
        EFaceWinding,
        ECompareFunc,
        EStencilOp,
        EBlendFactor,
        EBlendEquation,
        EColorMask,
        EPixelType,
        ELoadAction,
        EDataModelType,
        EMeshRenderType,
        EPrimitiveType,
        EShadowMode,
        EShadowFitMode,
        EVertexLayoutUsage,
        EVertexBatchOperator,
        EAnimationBlendType,
        EUseDefaultAddedAction,
        EUseDefaultRetainedAction,
        EUseDefaultRemovedAction,
        EEventType,
        EARTrackerState,
        EShapeType,
        ECapsuleShapeDirection
    } from 'XrFrame/xrFrameSystem'

    export type Component<IData> = xrFrameSystem.Component<IData>
    export type Element = xrFrameSystem.Element
    export type EventManager = xrFrameSystem.EventManager
    export type Effect = xrFrameSystem.Effect
    export type Geometry = xrFrameSystem.Geometry
    export type Material = xrFrameSystem.Material
    export type VideoTexture = xrFrameSystem.VideoTexture
    export type RenderTexture = xrFrameSystem.RenderTexture
    export type GLTFModel = xrFrameSystem.GLTFModel
    export type EnvData = xrFrameSystem.EnvData
    export type Animation = xrFrameSystem.Animation
    export type KeyframeAnimation = xrFrameSystem.KeyframeAnimation
    export type Atlas = xrFrameSystem.Atlas
    export type PostProcess = xrFrameSystem.PostProcess
    export type Vector2 = xrFrameSystem.Vector2
    export type Vector3 = xrFrameSystem.Vector3
    export type Vector4 = xrFrameSystem.Vector4
    export type Quaternion = xrFrameSystem.Quaternion
    export type Matrix3 = xrFrameSystem.Matrix3
    export type Matrix4 = xrFrameSystem.Matrix4
    export type Color = xrFrameSystem.Color
    export type OBB = xrFrameSystem.OBB
    export type BoundBall = xrFrameSystem.BoundBall
    export type BoundBox = xrFrameSystem.BoundBox
    export type Spherical = xrFrameSystem.Spherical
    export type Transform = xrFrameSystem.Transform
    export type AssetLoad = xrFrameSystem.AssetLoad
    export type Assets = xrFrameSystem.Assets
    export type Camera = xrFrameSystem.Camera
    export type GLTF = xrFrameSystem.GLTF
    export type Light = xrFrameSystem.Light
    export type AssetMaterial = xrFrameSystem.AssetMaterial
    export type Mesh = xrFrameSystem.Mesh
    export type Text = xrFrameSystem.Text
    export type Particle = xrFrameSystem.Particle
    export type AssetRenderTexture = xrFrameSystem.AssetRenderTexture
    export type Env = xrFrameSystem.Env
    export type Animator = xrFrameSystem.Animator
    export type CameraOrbitControl = xrFrameSystem.CameraOrbitControl
    export type ARTracker = xrFrameSystem.ARTracker
    export type Shape = xrFrameSystem.Shape
    export type SphereShape = xrFrameSystem.SphereShape
    export type MeshShape = xrFrameSystem.MeshShape
    export type CapsuleShape = xrFrameSystem.CapsuleShape
    export type CubeShape = xrFrameSystem.CubeShape
    export type ShapeGizmos = xrFrameSystem.ShapeGizmos
    export type AssetPostProcess = xrFrameSystem.AssetPostProcess
    export type Scene = xrFrameSystem.Scene
    export type XRNode = xrFrameSystem.XRNode
    export type XRShadow = xrFrameSystem.XRShadow
    export type XRCamera = xrFrameSystem.XRCamera
    export type XRMesh = xrFrameSystem.XRMesh
    export type XRLight = xrFrameSystem.XRLight
    export type XRGLTF = xrFrameSystem.XRGLTF
    export type XRMaterial = xrFrameSystem.XRMaterial
    export type XRAssetRenderTexture = xrFrameSystem.XRAssetRenderTexture
    export type XRAssetLoad = xrFrameSystem.XRAssetLoad
    export type XRAssets = xrFrameSystem.XRAssets
    export type XREnv = xrFrameSystem.XREnv
    export type XRARTracker = xrFrameSystem.XRARTracker
    export type XRText = xrFrameSystem.XRText
    export type XRParticle = xrFrameSystem.XRParticle
    export type XRAssetPostProcess = xrFrameSystem.XRAssetPostProcess
    export type AssetsSystem = xrFrameSystem.AssetsSystem
    export type NodeSystem = xrFrameSystem.NodeSystem
    export type TickSystem = xrFrameSystem.TickSystem
    export type AnimationSystem = xrFrameSystem.AnimationSystem
    export type VideoSystem = xrFrameSystem.VideoSystem
    export type RenderSystem = xrFrameSystem.RenderSystem
    export type PhysicsSystem = xrFrameSystem.PhysicsSystem
    export type ARSystem = xrFrameSystem.ARSystem
    export type ShareSystem = xrFrameSystem.ShareSystem
    export type GizmoSystem = xrFrameSystem.GizmoSystem
    export type AssetLoader<T, ILoadOptions> = xrFrameSystem.AssetLoader<
        T,
        ILoadOptions
    >
    export type TextureLoader = xrFrameSystem.TextureLoader
    export type ImageLoader = xrFrameSystem.ImageLoader
    export type CubeTextureLoader = xrFrameSystem.CubeTextureLoader
    export type VideoTextureLoader = xrFrameSystem.VideoTextureLoader
    export type EnvDataLoader = xrFrameSystem.EnvDataLoader
    export type GlTFLoader = xrFrameSystem.GlTFLoader
    export type KeyframeLoader = xrFrameSystem.KeyframeLoader
    export type RawLoader = xrFrameSystem.RawLoader
    export type AtlasLoader = xrFrameSystem.AtlasLoader

    export interface IXrFrameSystem {
        registerComponent: typeof xrFrameSystem.registerComponent
        registerElement: typeof xrFrameSystem.registerElement
        registerDataValue: typeof xrFrameSystem.registerDataValue
        isTextureWrapper: typeof xrFrameSystem.isTextureWrapper
        registerEffect: typeof xrFrameSystem.registerEffect
        registerGeometry: typeof xrFrameSystem.registerGeometry
        registerTexture: typeof xrFrameSystem.registerTexture
        registerMaterial: typeof xrFrameSystem.registerMaterial
        registerUniformDesc: typeof xrFrameSystem.registerUniformDesc
        registerVertexDataDesc: typeof xrFrameSystem.registerVertexDataDesc
        registerVertexLayout: typeof xrFrameSystem.registerVertexLayout
        registerAssetLoader: typeof xrFrameSystem.registerAssetLoader
        Component: typeof xrFrameSystem.Component
        Element: typeof xrFrameSystem.Element
        EventManager: typeof xrFrameSystem.EventManager
        Effect: typeof xrFrameSystem.Effect
        Geometry: typeof xrFrameSystem.Geometry
        Material: typeof xrFrameSystem.Material
        VideoTexture: typeof xrFrameSystem.VideoTexture
        RenderTexture: typeof xrFrameSystem.RenderTexture
        GLTFModel: typeof xrFrameSystem.GLTFModel
        EnvData: typeof xrFrameSystem.EnvData
        Animation: typeof xrFrameSystem.Animation
        KeyframeAnimation: typeof xrFrameSystem.KeyframeAnimation
        Atlas: typeof xrFrameSystem.Atlas
        PostProcess: typeof xrFrameSystem.PostProcess
        Vector2: typeof xrFrameSystem.Vector2
        Vector3: typeof xrFrameSystem.Vector3
        Vector4: typeof xrFrameSystem.Vector4
        Quaternion: typeof xrFrameSystem.Quaternion
        Matrix3: typeof xrFrameSystem.Matrix3
        Matrix4: typeof xrFrameSystem.Matrix4
        Color: typeof xrFrameSystem.Color
        OBB: typeof xrFrameSystem.OBB
        BoundBall: typeof xrFrameSystem.BoundBall
        BoundBox: typeof xrFrameSystem.BoundBox
        Spherical: typeof xrFrameSystem.Spherical
        Transform: typeof xrFrameSystem.Transform
        AssetLoad: typeof xrFrameSystem.AssetLoad
        Assets: typeof xrFrameSystem.Assets
        Camera: typeof xrFrameSystem.Camera
        GLTF: typeof xrFrameSystem.GLTF
        Light: typeof xrFrameSystem.Light
        AssetMaterial: typeof xrFrameSystem.AssetMaterial
        Mesh: typeof xrFrameSystem.Mesh
        Text: typeof xrFrameSystem.Text
        Particle: typeof xrFrameSystem.Particle
        AssetRenderTexture: typeof xrFrameSystem.AssetRenderTexture
        Env: typeof xrFrameSystem.Env
        Animator: typeof xrFrameSystem.Animator
        CameraOrbitControl: typeof xrFrameSystem.CameraOrbitControl
        ARTracker: typeof xrFrameSystem.ARTracker
        Shape: typeof xrFrameSystem.Shape
        SphereShape: typeof xrFrameSystem.SphereShape
        MeshShape: typeof xrFrameSystem.MeshShape
        CapsuleShape: typeof xrFrameSystem.CapsuleShape
        CubeShape: typeof xrFrameSystem.CubeShape
        ShapeGizmos: typeof xrFrameSystem.ShapeGizmos
        AssetPostProcess: typeof xrFrameSystem.AssetPostProcess
        Scene: typeof xrFrameSystem.Scene
        XRNode: typeof xrFrameSystem.XRNode
        XRShadow: typeof xrFrameSystem.XRShadow
        XRCamera: typeof xrFrameSystem.XRCamera
        XRMesh: typeof xrFrameSystem.XRMesh
        XRLight: typeof xrFrameSystem.XRLight
        XRGLTF: typeof xrFrameSystem.XRGLTF
        XRMaterial: typeof xrFrameSystem.XRMaterial
        XRAssetRenderTexture: typeof xrFrameSystem.XRAssetRenderTexture
        XRAssetLoad: typeof xrFrameSystem.XRAssetLoad
        XRAssets: typeof xrFrameSystem.XRAssets
        XREnv: typeof xrFrameSystem.XREnv
        XRARTracker: typeof xrFrameSystem.XRARTracker
        XRText: typeof xrFrameSystem.XRText
        XRParticle: typeof xrFrameSystem.XRParticle
        XRAssetPostProcess: typeof xrFrameSystem.XRAssetPostProcess
        AssetsSystem: typeof xrFrameSystem.AssetsSystem
        NodeSystem: typeof xrFrameSystem.NodeSystem
        TickSystem: typeof xrFrameSystem.TickSystem
        AnimationSystem: typeof xrFrameSystem.AnimationSystem
        VideoSystem: typeof xrFrameSystem.VideoSystem
        RenderSystem: typeof xrFrameSystem.RenderSystem
        PhysicsSystem: typeof xrFrameSystem.PhysicsSystem
        ARSystem: typeof xrFrameSystem.ARSystem
        ShareSystem: typeof xrFrameSystem.ShareSystem
        GizmoSystem: typeof xrFrameSystem.GizmoSystem
        AssetLoader: typeof xrFrameSystem.AssetLoader
        TextureLoader: typeof xrFrameSystem.TextureLoader
        ImageLoader: typeof xrFrameSystem.ImageLoader
        CubeTextureLoader: typeof xrFrameSystem.CubeTextureLoader
        VideoTextureLoader: typeof xrFrameSystem.VideoTextureLoader
        EnvDataLoader: typeof xrFrameSystem.EnvDataLoader
        GlTFLoader: typeof xrFrameSystem.GlTFLoader
        KeyframeLoader: typeof xrFrameSystem.KeyframeLoader
        RawLoader: typeof xrFrameSystem.RawLoader
        AtlasLoader: typeof xrFrameSystem.AtlasLoader
        EVertexFormat: typeof xrFrameSystem.EVertexFormat
        EVertexStep: typeof xrFrameSystem.EVertexStep
        EIndexType: typeof xrFrameSystem.EIndexType
        ETextureType: typeof xrFrameSystem.ETextureType
        ETextureFormat: typeof xrFrameSystem.ETextureFormat
        EWrapMode: typeof xrFrameSystem.EWrapMode
        EFilterMode: typeof xrFrameSystem.EFilterMode
        EUniformType: typeof xrFrameSystem.EUniformType
        ECullMode: typeof xrFrameSystem.ECullMode
        EFaceWinding: typeof xrFrameSystem.EFaceWinding
        ECompareFunc: typeof xrFrameSystem.ECompareFunc
        EStencilOp: typeof xrFrameSystem.EStencilOp
        EBlendFactor: typeof xrFrameSystem.EBlendFactor
        EBlendEquation: typeof xrFrameSystem.EBlendEquation
        EColorMask: typeof xrFrameSystem.EColorMask
        EPixelType: typeof xrFrameSystem.EPixelType
        ELoadAction: typeof xrFrameSystem.ELoadAction
        EDataModelType: typeof xrFrameSystem.EDataModelType
        EMeshRenderType: typeof xrFrameSystem.EMeshRenderType
        EPrimitiveType: typeof xrFrameSystem.EPrimitiveType
        EShadowMode: typeof xrFrameSystem.EShadowMode
        EShadowFitMode: typeof xrFrameSystem.EShadowFitMode
        EVertexLayoutUsage: typeof xrFrameSystem.EVertexLayoutUsage
        EVertexBatchOperator: typeof xrFrameSystem.EVertexBatchOperator
        EAnimationBlendType: typeof xrFrameSystem.EAnimationBlendType
        EUseDefaultAddedAction: typeof xrFrameSystem.EUseDefaultAddedAction
        EUseDefaultRetainedAction: typeof xrFrameSystem.EUseDefaultRetainedAction
        EUseDefaultRemovedAction: typeof xrFrameSystem.EUseDefaultRemovedAction
        EEventType: typeof xrFrameSystem.EEventType
        EARTrackerState: typeof xrFrameSystem.EARTrackerState
        EShapeType: typeof xrFrameSystem.EShapeType
        ECapsuleShapeDirection: typeof xrFrameSystem.ECapsuleShapeDirection
        useParamsEaseFuncs: typeof xrFrameSystem.useParamsEaseFuncs
        noneParamsEaseFuncs: typeof xrFrameSystem.noneParamsEaseFuncs
        TransformSchema: IComponentSchema
        AssetLoadSchema: IComponentSchema
        AssetsSchema: IComponentSchema
        CameraSchema: IComponentSchema
        GLTFSchema: IComponentSchema
        LightSchema: IComponentSchema
        AssetMaterialSchema: IComponentSchema
        MeshSchema: IComponentSchema
        TextSchema: IComponentSchema
        AssetRenderTextureSchema: IComponentSchema
        EnvSchema: IComponentSchema
        AnimatorSchema: IComponentSchema
        CameraOrbitControlSchema: IComponentSchema
        ARTrackSchema: IComponentSchema
        SphereShapeSchema: IComponentSchema
        MeshShapeSchema: IComponentSchema
        CapsuleShapeSchema: IComponentSchema
        CubeShapeSchema: IComponentSchema
        ParticleSchema: IComponentSchema
        RenderSystemSchema: IComponentSchema
        ARSystemSchema: IComponentSchema
        BasicDefaultComponents: IEntityComponents
        SceneDefaultComponents: IEntityComponents
        NodeDefaultComponents: IEntityComponents
        ShadowDefaultComponents: IEntityComponents
        CameraDefaultComponents: IEntityComponents
        MeshDefaultComponents: IEntityComponents
        LightDefaultComponents: IEntityComponents
        GLTFDefaultComponents: IEntityComponents
        AssetMaterialDefaultComponents: IEntityComponents
        AssetRenderTextureDefaultComponents: IEntityComponents
        AssetsDefaultComponents: IEntityComponents
        EnvDefaultComponents: IEntityComponents
        ARTrackerDefaultComponents: IEntityComponents
        TextDefaultComponents: IEntityComponents
        ParticleDefaultComponents: IEntityComponents
        AssetPostProcessDefaultComponents: IEntityComponents
        BasicDataMapping: { [key: string]: string[] }
        SceneDataMapping: { [key: string]: string[] }
        NodeDataMapping: { [key: string]: string[] }
        ShadowDataMapping: { [key: string]: string[] }
        CameraDataMapping: { [key: string]: string[] }
        MeshDataMapping: { [key: string]: string[] }
        LightDataMapping: { [key: string]: string[] }
        GLTFDataMapping: { [key: string]: string[] }
        AssetMaterialDataMapping: { [key: string]: string[] }
        AssetRenderTextureDataMapping: { [key: string]: string[] }
        AssetLoadDataMapping: { [key: string]: string[] }
        EnvDataMapping: { [key: string]: string[] }
        ARTrackerDataMapping: { [key: string]: string[] }
        TextDataMapping: { [key: string]: string[] }
        ParticleDataMapping: { [key: string]: string[] }
        AssetPostProcessDataMapping: { [key: string]: string[] }
    }
}

declare module 'XrFrame/xrFrameSystem' {
    /**
     * xrFrameSystem.ts
     *
     *       * @Date    : 4/28/2022, 5:02:28 PM
     */
    import { Kanata } from 'XrFrame/ext'
    export {
        default as Component,
        registerComponent,
        IComponentSchema
    } from 'XrFrame/core/Component'
    export {
        default as Element,
        registerElement,
        IEntityComponents,
        BasicDefaultComponents,
        BasicDataMapping
    } from 'XrFrame/core/Element'
    export {
        registerDataValue,
        IDataValueHandler,
        ITextureWrapper,
        isTextureWrapper
    } from 'XrFrame/core/DataValue'
    export {
        default as EventManager,
        TEventCallback
    } from 'XrFrame/core/EventManager'
    export * from 'XrFrame/components'
    export * from 'XrFrame/elements'
    export * from 'XrFrame/systems'
    export * from 'XrFrame/loader'
    export {
        default as Effect,
        IEffectAsset,
        IRenderStates
    } from 'XrFrame/assets/Effect'
    export { default as Geometry, ISubMesh } from 'XrFrame/assets/Geometry'
    export { default as Material } from 'XrFrame/assets/Material'
    export {
        default as VideoTexture,
        IVideoTextureOptions
    } from 'XrFrame/assets/VideoTexture'
    export {
        default as RenderTexture,
        IRenderTarget,
        IRenderTextureOptions
    } from 'XrFrame/assets/RenderTexture'
    export {
        default as GLTFModel,
        IGLTFModelOptions
    } from 'XrFrame/assets/GLTFModel'
    export { default as EnvData, IEnvDataOptions } from 'XrFrame/assets/EnvData'
    export {
        default as Animation,
        TDirection
    } from 'XrFrame/animation/Animation'
    export {
        default as KeyframeAnimation,
        IKeyframeAnimationData,
        IKeyframeAnimationInfo,
        IKeyframeAnimationOptions
    } from 'XrFrame/animation/KeyframeAnimation'
    export {
        default as Atlas,
        IAtlasOptions,
        IAtlasCreationOptions
    } from 'XrFrame/assets/Atlas'
    export {
        default as PostProcess,
        IPostProcessOptions
    } from 'XrFrame/assets/PostProcess'
    export {
        registerEffect,
        registerGeometry,
        registerTexture,
        registerMaterial,
        registerUniformDesc,
        registerVertexDataDesc,
        registerVertexLayout
    } from 'XrFrame/assets/factories'
    export {
        useParamsEaseFuncs,
        noneParamsEaseFuncs
    } from 'XrFrame/assets/easeFunctions'
    export { default as Vector2 } from 'XrFrame/math/vector2'
    export { default as Vector3 } from 'XrFrame/math/vector3'
    export { default as Vector4 } from 'XrFrame/math/vector4'
    export { default as Quaternion } from 'XrFrame/math/quaternion'
    export { default as Matrix3 } from 'XrFrame/math/matrix3'
    export { default as Matrix4 } from 'XrFrame/math/matrix4'
    export { default as Color } from 'XrFrame/math/color'
    export { default as OBB } from 'XrFrame/math/OBB'
    export { default as BoundBall } from 'XrFrame/math/boundBall'
    export { default as BoundBox } from 'XrFrame/math/boundBox'
    export { default as Spherical } from 'XrFrame/math/Spherical'
    export {
        ITextureOptions,
        IEngineSettings,
        EVertexFormat,
        EVertexStep,
        EIndexType,
        ETextureType,
        ETextureFormat,
        EWrapMode,
        EFilterMode,
        EUniformType,
        ECullMode,
        EFaceWinding,
        ECompareFunc,
        EStencilOp,
        EBlendFactor,
        EBlendEquation,
        EColorMask,
        EPixelType,
        ELoadAction,
        EDataModelType,
        EMeshRenderType,
        EPrimitiveType,
        EShadowMode,
        EShadowFitMode,
        EVertexLayoutUsage,
        EVertexBatchOperator,
        EAnimationBlendType,
        EUseDefaultAddedAction,
        EUseDefaultRetainedAction,
        EUseDefaultRemovedAction,
        IHandle,
        IVertexLayoutOptions,
        IVertexDataDescriptorOptions,
        IUniformDescriptorOptions,
        IImage,
        IRealDownloader,
        IDownloader,
        IFontSetting,
        IFeatures,
        IRect,
        IViewAction,
        IView,
        IAttachment,
        IRenderPassDescriptor,
        EEventType,
        IGlyphInfo,
        IEventBridge,
        INativeMap,
        ILongIntNativeMap
    } from 'XrFrame/kanata/lib/kanata'
    export type Texture = Kanata.Texture
    export type UniformDescriptor = Kanata.UniformDescriptor
    export type UniformBlock = Kanata.UniformBlock
    export type VertexLayout = Kanata.VertexLayout
}

declare module 'XrFrame/ext' {
    /**
     * ext.ts
     *
     *       * @Date    : 2022/3/17下午1:43:48
     */
    import * as Kanata from 'XrFrame/kanata/lib/kanata'
    const exparser: any
    type Scene = import('XrFrame/core/Scene').default
    const _wx: any
    const Phys3D: any
    function addKanata(scene: Scene, kanata: Kanata.IKanataInstance): void
    function removeKanata(scene: Scene): void
    function getKanata(scene: Scene): Kanata.IKanataInstance
    function __getKanataSuperHackDontUseIt(): Kanata.IKanataInstance
    export {
        Kanata,
        exparser,
        Phys3D,
        _wx,
        addKanata,
        removeKanata,
        getKanata,
        __getKanataSuperHackDontUseIt
    }
}

declare module 'XrFrame/core/Component' {
    type Element = import('XrFrame/core/Element').default
    /**
     * `Component`属性的注解接口。
     *
     * `key`是可以写在组件对应于`xml`中的属性的名字。
     * `type`是属性的类型，由{@link registerDataValue}注册。
     * 可选的`defaultValue`可以定义默认值。
     */
    export interface IComponentSchema {
        [key: string]: {
            type: string
            defaultValue?: any
        }
    }
    /**
     * 组件，系统核心之一。
     *
     * 组件就是`wxml`的标签上写的那些`attribute`，比如`<xr-element transform="position: 1 1 1" />`中，`transform`就是一个组件，`position`是它的一个属性。
     * 这些属性可以在`schema`中被定义，变化时会触发对应的生命周期。
     * 自定义组件最后使用{@link registerComponent}，组件的属性可以使用代理规则来简化，比如以上的标签可以简化为`<xr-element position="1 1 1" />`，详见{@link Element}。
     *
     * @template IData 组件数据的类型，应当和`schema`中一致，用于TS类型推断。
     */
    export default class Component<IData> {
        /**
         * @internal
         */
        static TYPE: string
        /**
         * @internal
         */
        static SPLIT_DATA(dataStr: string): {
            [key: string]: string
        }
        /**
         * 自定义组件的`schema`。
         */
        readonly schema: IComponentSchema
        /**
         * 自定义组件的更新优先级。
         */
        readonly priority: number
        __DATA_TYPE: IData
        protected _version: number
        protected _currentData: IData
        /**
         * 挂载的元素。
         */
        get el(): import('XrFrame/core/Element').default
        /**
         * 当前场景。
         */
        get scene(): import('XrFrame/core/Scene').default
        /**
         * 当前版本，每次有数据更新都会增加，可以用作和其他组件合作的依据。
         */
        get version(): number
        /**
         * 不通过`xml`而是直接设置`data`，注意值的类型需要和`schema`中一致。
         */
        setData(data: Partial<IData>): void
        /**
         * 设置一个数据。
         */
        setDataOne<T extends keyof IData>(key: T, value: IData[T]): void
        /**
         * 获取一个当前值。
         */
        getData<T extends keyof IData>(key: T): IData[T]
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * 所挂载的`element`被挂载到场景时触发的回调。
         */
        onAdd(parent: Element, data: IData): void
        /**
         * 数据更新时触发的回调。
         */
        onUpdate(data: IData, preData: IData): void
        /**
         * 渲染每帧触发的回调。
         */
        onTick(deltaTime: number, data: IData): void
        /**
         * 所挂载的`element`从父节点`parent`被移除时，或者自己从`element`上被移除时，触发的回调。
         * 一般用于消除功能的运作。
         */
        onRemove(parent: Element, data: IData): void
        /**
         * 从被挂载的`element`上被移除，或是`element`被销毁时，触发的回调。
         * 一般用于释放持有的资源。
         */
        onRelease(data: IData): void
    }
    /**
     * @internal
     */
    export function getComponent(type: string): new () => Component<any>
    /**
     * 向系统中注册一个组件，然后可以在`xml`中使用。
     */
    export function registerComponent(
        type: string,
        clz: new () => Component<any>
    ): void
    export {}
}

declare module 'XrFrame/core/Element' {
    /**
     * Element.ts
     *
     *         * @Date    : 2022/4/1上午10:34:06
     */
    import Component from 'XrFrame/core/Component'
    import EventManager, {
        TFrameworkEventTrigger
    } from 'XrFrame/core/EventManager'
    /**
     * `Element`的默认组件集接口。
     *
     * `name`是组件注册时的名字，`key`是要默认设置的组件的属性名字，值是默认值，但应当和`xml`中一致，为**字符串**。
     */
    export interface IEntityComponents {
        [name: string]: {
            [key: string]: string
        }
    }
    /**
     * 空的默认组件集。
     */
    export const BasicDefaultComponents: IEntityComponents
    /**
     * 空的默认组件映射。
     */
    export const BasicDataMapping: {
        [key: string]: string[]
    }
    /**
     * 元素，系统核心之一。
     *
     * 本质上就是对应于`xml`中标签，所有的标签的实现都是继承自`Element`的，其一般不包含逻辑，仅仅是通过`defaultComponents`和`dataMapping`定义组件的集合与映射。
     * 自定义元素最后使用{#@link registerElement}。
     */
    export default class Element {
        static TYPE: string
        /**
         * `Element`的默认组件集合，详见{@link IEntityComponents}。
         */
        readonly defaultComponents: IEntityComponents
        /**
         * `Element`的数据映射。它是为了给组件的属性提供一个方便的用法，比如：
         * ```ts
         * {
         *   position: [transform, position]
         * }
         * ```
         * 就是将`xml`中写在这个`Element`的`position`直接映射到了`transform`组件的`position`属性上。
         *
         * **通常来讲，所有的驼峰如`nodeId`都会被映射为小写加中划线`node-id`**。
         */
        readonly dataMapping: {
            [key: string]: string[]
        }
        /**
         * @internal
         */
        readonly neverTick: boolean
        /**
         * 名字，写在`xml`上的那个`name`，不唯一。
         */
        get name(): string
        set name(value: string)
        /**
         * @internal
         */
        /**
         * 元素是否在`xml`中，若是`xr-shadow`下的节点，则为`false`。
         */
        get inXML(): boolean
        /**
         * 场景实例。
         */
        get scene(): import('XrFrame/core/Scene').default
        /**
         * 父元素。
         */
        get parent(): Element
        /**
         * 事件管理器。
         */
        get event(): EventManager
        constructor(_type: string, triggerEvent: TFrameworkEventTrigger)
        /**
         * 获取第`index`个子元素。
         */
        getChildAtIndex<T extends Element = Element>(index: number): T
        /**
         * 通过`filter`获取子元素。
         */
        getChildByFilter<T extends Element = Element>(
            filter: (child: Element) => boolean
        ): T
        /**
         * 通过`filter`获取子元素列表。
         */
        getChildrenByFilter(filter: (child: Element) => boolean): Element[]
        /**
         * 通过元素的类获取子元素。
         */
        getChildByClass<T extends Element = Element>(
            clz: new (...args: any[]) => T
        ): T
        /**
         * 通过元素的名字`name`获取子元素。
         */
        getChildByName<T extends Element = Element>(name: string): T
        /**
         * 通过元素的名字`name`获取子元素们。
         */
        getChildrenByName(name: string): Element[]
        /**
         * 递归遍历元素的所有子孙节点。
         */
        dfs<T extends any>(
            callback: (element: Element, params?: T) => T,
            defaultParams?: T,
            excludeRoot?: boolean,
            stop?: (element: Element, params?: T) => boolean
        ): void
        /**
         * 手动添加一个`Component`。
         */
        addComponent<T extends Component<any>>(
            clz: new () => T,
            options?: T['__DATA_TYPE']
        ): T
        /**
         * 获取一个`Component`，可以使用类或者名字获取。
         */
        getComponent<T extends Component<any>>(clzName: string): T
        getComponent<T extends Component<any>>(clz: new () => T): T
        /**
         * 手动移除一个`Component`，注意保证其不在`xml`上。
         */
        removeComponent(clz: new () => Component<any>): void
        /**
         * 设置一个属性，对应于`xml`标签中的那些属性，值为字符串。
         * **一般建议使用`component`的`setData`方法**！！！
         */
        setAttribute(name: string, value: string): void
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * @internal
         */
        _associateValue(_v: any): void
        /**
         * 手动添加一个子节点，**注意需要保证当前节点是`xr-shadow`或其子节点**。
         */
        addChild(child: Element): void
        /**
         * 手动移除一个子节点，**注意需要保证当前节点是`xr-shadow`或其子节点**。
         */
        removeChild(child: Element): void
        /**
         * 仅限自己创建的节点使用，否则后果自负。
         */
        setId(id: string): void
        /**
         * 仅限自己创建的节点使用，否则后果自负。
         */
        release(): void
        /**
         * @internal
         */
        _appendChild(_child: Element, custom?: boolean): void
        /**
         * @internal
         */
        _removeChild(_child: Element, _index?: number, custom?: boolean): void
        /**
         * @internal
         */
        _insertBefore(_child: Element, _before?: Element, _index?: number): void
        /**
         * @internal
         */
        _replaceChild(
            _child: Element,
            _oldChild?: Element,
            _index?: number
        ): void
        /**
         * @internal
         */
        _spliceBefore(
            _before: number | Element,
            _deleteCount: number,
            _list: Element
        ): void
        /**
         * @internal
         */
        _spliceAppend(_list: Element): void
        /**
         * @internal
         */
        _spliceRemove(_before: Element, _deleteCount: number): void
        /**
         * @internal
         */
        _setId(_id: string): void
        /**
         * @internal
         */
        _setStyleScope(_styleScope: number): void
        /**
         * @internal
         */
        _setStyle(_styleText: string): void
        /**
         * @internal
         */
        _addClass(_elementClass: string, _styleScope?: number): void
        /**
         * @internal
         */
        _removeClass(_elementClass: string, _styleScope?: number): void
        /**
         * @internal
         */
        /**
         * @internal
         */
        _setAttribute(_name: string, _value: string): void
        _removeAttribute(_name: string): void
        _setText(_content: string): void
    }
    export function getElement(type: string): typeof Element
    /**
     * 注册一个自定义元素。
     * 注意注册的`type`在`xml`中使用时需要加上`xr-`前缀，比如注册`custom`类型的元素，使用时需要时`xr-custom`。
     */
    export function registerElement(type: string, clz: typeof Element): void
}

declare module 'XrFrame/core/DataValue' {
    /**
     * DataValue.ts
     *
     *         * @Date    : 2022/3/17下午2:22:19
     */
    import { Kanata } from 'XrFrame/ext'
    import Scene from 'XrFrame/core/Scene'
    /**
     * 详见{@link registerDataValue}。
     */
    export interface IDataValueHandler<TDataValue> {
        create(value: string, defaultValue: any, scene: Scene): TDataValue
    }
    export interface ITextureWrapper {
        texture: Kanata.Texture
    }
    export function isTextureWrapper(value: any): value is ITextureWrapper
    export function isDataValueHandlerExisted(type: string): boolean
    /**
     * 为组件在`xml`中写的属性值按类型注册解析器，由于`xml`传入的值全部都是字符串，所以需要解析，比如：
     * ```ts
     * registerDataValue('number', {create: (value: string, defaultValue: any, scene: Scene) => {
     *   return value === undefined ? defaultValue : parseFloat(value));
     * }});
     * ```
     * 就是注册了`number`类型，后续在组件的`schema`中写的`number`类型数据，就会走这个解析器。
     * **注意最后一个参数`scene`可以用于获取资源等，比如`scene.assets.getAssetWithState(type, value, defaultValue)`。**
     * **如果是被资源加载器加载的资源，则会在资源加载器注册时自动注册数据类型，详见{@link AssetLoader}**。
     *
     * 已经注册的类型可见[组件数据解析](../../../component/xr-frame/core/data-values)。
     */
    export function registerDataValue<TDataValue>(
        type: string,
        handler: IDataValueHandler<TDataValue>
    ): void
    export function parseDataValue<TDataValue>(
        type: string,
        value: string,
        defaultValue: any,
        scene: Scene
    ): TDataValue
}

declare module 'XrFrame/core/EventManager' {
    /**
     * EventManager.ts
     *
     *         * @Date    : 2022/3/17下午3:54:03
     */
    import Observable from 'XrFrame/core/Observable'
    type Element = import('XrFrame/core/Element').default
    /**
     * 事件管理器的回调。
     */
    export type TEventCallback<TParams> = (
        params: TParams,
        sender: Element
    ) => void
    export type TFrameworkEventTrigger = (
        name: string,
        details: any,
        options: {
            bubbles?: boolean
            composed?: boolean
            capturePhase?: boolean
        }
    ) => void
    /**
     * 事件管理器。
     *
     * 每个`Element`都有自己的事件管理器，通过参数可以触发到`xml`。
     */
    export default class EventManager {
        isEventManager: boolean
        protected _observables: {
            [type: string]: Observable
        }
        protected _caches: {
            [type: string]: {
                value: any
                toXML: boolean
                bubbles: boolean
            }
        }
        constructor(_el: Element, _triggerElementEvent: TFrameworkEventTrigger)
        /**
         * 添加一个事件监听器。
         */
        add<TEvent = any>(
            type: string,
            callback: TEventCallback<TEvent>,
            priority?: number
        ): this
        /**
         * 添加一个事件监听器，触发一次后自动移除。
         */
        addOnce<TEvent = any>(
            type: string,
            callback: TEventCallback<TEvent>,
            priority?: number
        ): this
        /**
         * 移除一个事件监听器。
         */
        remove<TEvent = any>(
            type: string,
            callback: TEventCallback<TEvent>
        ): this
        /**
         * 判断一个事件是否被注册。
         */
        has(type: string): boolean
        /**
         * 获取一个事件监听者数量。
         * @internal
         */
        getCount(type: string): number
        /**
         * 清空某事件的所有监听器。
         */
        clear(type: string): this
        /**
         * 触发一个事件。
         *
         * @param type 要触发的事件类型。
         * @param event 事件的值。
         * @param immediately 是否要将事件立即分发，如果不则会先缓存，之后在每一帧更新前统一分发，避免不必要的分发。
         * @param toXML 是否要派发到`xml`绑定的事件中。
         * @param bubbles 是否要进行事件冒泡。
         */
        trigger<TEvent = any>(
            type: string,
            event?: TEvent,
            immediately?: boolean,
            toXML?: boolean,
            bubbles?: boolean
        ): this
        /**
         * 分发某个缓存的事件，一般不需要自行触发。
         */
        flush(type: string): this
        /**
         * 分发所有缓存的事件，一般不需要自行触发。
         */
        flushAll(): this
    }
    export {}
}

declare module 'XrFrame/components' {
    export {
        default as Transform,
        ITransformData,
        TransformSchema
    } from 'XrFrame/components/Transform'
    export {
        default as AssetLoad,
        AssetLoadSchema
    } from 'XrFrame/components/AssetLoad'
    export {
        default as Assets,
        IAssetsData,
        AssetsSchema
    } from 'XrFrame/components/Assets'
    export {
        default as Camera,
        ICameraData,
        CameraSchema,
        TCameraBackground
    } from 'XrFrame/components/Camera'
    export {
        default as GLTF,
        IGLTFData,
        GLTFSchema
    } from 'XrFrame/components/GLTF'
    export {
        default as Light,
        ILightData,
        LightSchema
    } from 'XrFrame/components/Light'
    export {
        default as AssetMaterial,
        IAssetMaterialData,
        AssetMaterialSchema
    } from 'XrFrame/components/AssetMaterial'
    export {
        default as Mesh,
        IMeshData,
        MeshSchema
    } from 'XrFrame/components/Mesh'
    export {
        default as Text,
        ITextData,
        TextSchema
    } from 'XrFrame/components/Text'
    export { default as Particle } from 'XrFrame/components/particle/Particle'
    export {
        IParticleData,
        ParticleSchema
    } from 'XrFrame/components/particle/BasicParticle'
    export {
        default as AssetRenderTexture,
        IAssetRenderTextureData,
        AssetRenderTextureSchema
    } from 'XrFrame/components/AssetRenderTexture'
    export { default as Env, IEnvData, EnvSchema } from 'XrFrame/components/Env'
    export {
        default as Animator,
        IAnimatorData,
        AnimatorSchema,
        IAnimationPlayOptions,
        IAnimatorAutoPlay
    } from 'XrFrame/components/Animator'
    export {
        default as CameraOrbitControl,
        ICameraOrbitControlData,
        CameraOrbitControlSchema
    } from 'XrFrame/components/CameraOrbitControl'
    export {
        default as ARTracker,
        IARTrackerData,
        ARTrackSchema,
        TTrackMode,
        EARTrackerState,
        IARTrackerRawData
    } from 'XrFrame/components/ARTracker'
    export {
        default as Shape,
        IShapeData,
        EShapeType
    } from 'XrFrame/components/physics/Shape'
    export {
        default as SphereShape,
        ISphereShapeData,
        SphereShapeSchema
    } from 'XrFrame/components/physics/SphereShape'
    export {
        default as MeshShape,
        IMeshShapeData,
        MeshShapeSchema
    } from 'XrFrame/components/physics/MeshShape'
    export {
        default as CapsuleShape,
        ICapsuleShapeData,
        CapsuleShapeSchema,
        ECapsuleShapeDirection
    } from 'XrFrame/components/physics/CapsuleShape'
    export {
        default as CubeShape,
        ICubeShapeData,
        CubeShapeSchema
    } from 'XrFrame/components/physics/CubeShape'
    export {
        default as ShapeGizmos,
        IShapeGizmosData
    } from 'XrFrame/components/gizmo/ShapeGizmos'
    export {
        default as AssetPostProcess,
        IAssetPostProcessData
    } from 'XrFrame/components/AssetPostProcess'
}

declare module 'XrFrame/elements' {
    export {
        default as Scene,
        SceneDataMapping,
        SceneDefaultComponents
    } from 'XrFrame/core/Scene'
    export {
        default as XRNode,
        NodeDataMapping,
        NodeDefaultComponents
    } from 'XrFrame/elements/xr-node'
    export {
        default as XRShadow,
        ShadowDataMapping,
        ShadowDefaultComponents
    } from 'XrFrame/elements/xr-shadow'
    export {
        default as XRCamera,
        CameraDataMapping,
        CameraDefaultComponents
    } from 'XrFrame/elements/xr-camera'
    export {
        default as XRMesh,
        MeshDataMapping,
        MeshDefaultComponents
    } from 'XrFrame/elements/xr-mesh'
    export {
        default as XRLight,
        LightDataMapping,
        LightDefaultComponents
    } from 'XrFrame/elements/xr-light'
    export {
        default as XRGLTF,
        GLTFDataMapping,
        GLTFDefaultComponents
    } from 'XrFrame/elements/xr-gltf'
    export {
        default as XRMaterial,
        AssetMaterialDataMapping,
        AssetMaterialDefaultComponents
    } from 'XrFrame/elements/xr-asset-material'
    export {
        default as XRAssetRenderTexture,
        AssetRenderTextureDataMapping,
        AssetRenderTextureDefaultComponents
    } from 'XrFrame/elements/xr-asset-render-texture'
    export {
        default as XRAssetLoad,
        AssetLoadDataMapping
    } from 'XrFrame/elements/xr-asset-load'
    export {
        default as XRAssets,
        AssetsDefaultComponents
    } from 'XrFrame/elements/xr-assets'
    export {
        default as XREnv,
        EnvDataMapping,
        EnvDefaultComponents
    } from 'XrFrame/elements/xr-env'
    export {
        default as XRARTracker,
        ARTrackerDataMapping,
        ARTrackerDefaultComponents
    } from 'XrFrame/elements/xr-ar-tracker'
    export {
        default as XRText,
        TextDataMapping,
        TextDefaultComponents
    } from 'XrFrame/elements/xr-text'
    export {
        default as XRParticle,
        ParticleDataMapping,
        ParticleDefaultComponents
    } from 'XrFrame/elements/xr-particle'
    export {
        default as XRAssetPostProcess,
        AssetPostProcessDataMapping,
        AssetPostProcessDefaultComponents
    } from 'XrFrame/elements/xr-asset-post-process'
}

declare module 'XrFrame/systems' {
    export {
        default as AssetsSystem,
        IAssetsSystemData
    } from 'XrFrame/systems/AssetsSystem'
    export {
        default as NodeSystem,
        INodeSystemData
    } from 'XrFrame/systems/NodeSystem'
    export {
        default as TickSystem,
        ITickSystemData
    } from 'XrFrame/systems/TickSystem'
    export {
        default as AnimationSystem,
        IAnimationSystemData
    } from 'XrFrame/systems/AnimationSystem'
    export {
        default as VideoSystem,
        IVideoSystemData
    } from 'XrFrame/systems/VideoSystem'
    export {
        default as RenderSystem,
        IRenderSystemData,
        RenderSystemSchema
    } from 'XrFrame/systems/RenderSystem'
    export {
        default as PhysicsSystem,
        IPhysicsSystemData,
        IShapeDragEvent,
        IShapeTouchEvent
    } from 'XrFrame/systems/PhysicsSystem'
    export {
        default as ARSystem,
        IARSystemData,
        ARSystemSchema,
        IARRawData
    } from 'XrFrame/systems/ARSystem'
    export {
        default as ShareSystem,
        IShareSystemData,
        IShareCaptureOptions
    } from 'XrFrame/systems/ShareSystem'
    export {
        default as GizmoSystem,
        IGizmoSystemData
    } from 'XrFrame/systems/GizmoSystem'
}

declare module 'XrFrame/loader' {
    export {
        default as AssetLoader,
        ILoaderOptionsSchema,
        registerAssetLoader
    } from 'XrFrame/loader/AssetLoader'
    export {
        default as TextureLoader,
        ITextureLoaderOptions
    } from 'XrFrame/loader/TextureLoader'
    export {
        default as ImageLoader,
        IImageLoaderOptions
    } from 'XrFrame/loader/ImageLoader'
    export {
        default as CubeTextureLoader,
        ICubeTextureLoaderOptions
    } from 'XrFrame/loader/CubeTextureLoader'
    export {
        default as VideoTextureLoader,
        IVideoTextureLoaderOptions
    } from 'XrFrame/loader/VideoTextureLoader'
    export {
        default as EnvDataLoader,
        IEnvDataLoaderOptions
    } from 'XrFrame/loader/EnvDataLoader'
    export {
        default as GlTFLoader,
        IGLTFLoaderOptions
    } from 'XrFrame/loader/GlTFLoader'
    export {
        default as KeyframeLoader,
        IKeyframeLoaderOptions
    } from 'XrFrame/loader/KeyframeLoader'
    export {
        default as RawLoader,
        IRawLoaderOptions
    } from 'XrFrame/loader/RawLoader'
    export {
        default as AtlasLoader,
        IAtlasLoaderOptions
    } from 'XrFrame/loader/AtlasLoader'
}

declare module 'XrFrame/assets/Effect' {
    /**
     * Effect.ts
     *
     *         * @Date    : 2022/3/16下午4:44:48
     */
    import { ITextureWrapper } from 'XrFrame/core/DataValue'
    import { Kanata } from 'XrFrame/ext'
    import { IAssetWithState } from 'XrFrame/loader/types'
    type Scene = import('XrFrame/core/Scene').default
    /**
     * 支持定制的渲染状态。
     *
     * 大部分状态会定制的开发者应该看名字就懂，就不详细说明了。
     */
    export interface IRenderStates {
        /**
         * 渲染队列，大于等于`2500`为透明物体，否则为非透明物体。
         */
        renderQueue?: number
        blendOn?: boolean
        /**
         * 不要使用，使用`blendSrcRGB`。
         */
        blendSrc?: Kanata.EBlendFactor
        blendSrcRGB?: Kanata.EBlendFactor
        blendSrcAlpha?: Kanata.EBlendFactor
        /**
         * 不要使用，使用`blendDstRGB`。
         */
        blendDst?: Kanata.EBlendFactor
        blendDstRGB?: Kanata.EBlendFactor
        blendDstAlpha?: Kanata.EBlendFactor
        blendFunc?: Kanata.EBlendEquation
        cullOn?: boolean
        cullFace?: Kanata.ECullMode
        depthWrite?: boolean
        depthTestOn?: boolean
        depthTestComp?: Kanata.ECompareFunc
        stencilWriteMask?: number
        stencilTestOn?: boolean
        stencilRef?: number
        stencilReadMask?: number
        stencilComp?: Kanata.ECompareFunc
        stencilPass?: Kanata.EStencilOp
        stencilFail?: Kanata.EStencilOp
        stencilZFail?: Kanata.EStencilOp
        primitiveType?: Kanata.EPrimitiveType
    }
    /**
     * `Effect`资源的参数接口。
     */
    export interface IEffectAsset {
        /**
         * 名字，应当和`registerEffect`时的名字一致。
         */
        name: string
        /**
         * 属性，传给UniformBlock的一部分。
         */
        properties?: Array<{
            /**
             * 属性名字。
             */
            key: string
            /**
             * 属性类型。
             */
            type: Kanata.EUniformType
            /**
             * 如果属性是一个数组，比如`FLOAT4`数组，可以指定数组大小。
             */
            num?: number
            /**
             * 属性默认值，需要和类型匹配。
             */
            default: number[]
            /**
             * 属性对应的宏，当默认值被覆盖时，此宏开关会被开启，注意一定要有`WX_`前缀！
             */
            macro?: string
        }>
        /**
         * 纹理资源，传给UniformBlock的另一部分。
         */
        images?: Array<{
            /**
             * 属性名字。
             */
            key: string
            /**
             * 属性默认值，是`Texture`类型资源的`asset-id`。
             */
            default: string
            /**
             * 属性对应的宏，当默认值被覆盖时，此宏开关会被开启，注意一定要有`WX_`前缀！
             */
            macro?: string
        }>
        /**
         * 使用该`Effect`的`Material`的默认渲染队列。
         * 透明物体需要大于`2500`！
         */
        defaultRenderQueue: number
        /**
         * 渲染时的`passes`，渲染时指定的`lightMode`的每个`pass`都会被按顺序绘制。
         */
        passes: Array<{
            /**
             * 渲染的光照模式。
             */
            lightMode:
                | 'ForwardBase'
                | 'ForwardAdd'
                | 'ShadowCaster'
                | 'PostProcess'
                | 'Skybox'
                | string
            /**
             * 这个pass的渲染状态是否可以被`Material`覆盖。
             */
            useMaterialRenderStates: boolean
            /**
             * 这个pass的默认渲染状态。
             */
            renderStates?: IRenderStates
            /**
             * 这个pass的使用的`shader`在`shaders`中的索引，第一个是顶点着色器，第二个是片段着色器。
             */
            shaders: [number, number]
        }>
        /**
         * 所有的`shader`列表。
         */
        shaders: string[]
    }
    /**
     * 特效资源，定义了渲染所需的大部分参数，被{@link Material}所引用。
     */
    export default class Effect {
        protected _scene: Scene
        readonly description: IEffectAsset
        /**
         * 获取名称。
         */
        get name(): string
        /**
         * 获取场景实例。
         */
        get scene(): import('XrFrame/core/Scene').default
        /**
         * Backend对应的对象。
         * @internal
         */
        get kanataEffect(): import('XrFrame/kanata/lib/index').Effect
        /**
         * 有几个Pass。
         */
        get passCount(): number
        /**
         * 正在加载中的纹理。
         * @internal
         */
        get loadingTextures(): {
            [key: string]: IAssetWithState<
                import('XrFrame/kanata/lib/index').Texture | ITextureWrapper
            >
        }
        /**
         * 用于UniformBlock构建时传入
         * @internal
         */
        _shaderUniformBlockDesc?: Kanata.UniformDescriptor
        /**
         * 是否没有properties。
         * @internal
         */
        _isNoProperties: boolean
        /**
         * 是否没有images。
         * @internal
         */
        _isNoImages: boolean
        /**
         * 根据特效配置生成特效资源。
         * **注意，不建议自己创建，请使用`scene.createEffect`。**
         *
         * @param description 配置。
         */
        constructor(_scene: Scene, description: IEffectAsset)
        /**
         * 材质调用方法，拷贝默认UniformBlock。
         * @internal
         */
        /**
         * @internal
         */
        /**
         * 预编译
         */
        warmUp(): boolean
    }
    export {}
}

declare module 'XrFrame/assets/Geometry' {
    import { Kanata } from 'XrFrame/ext'
    import BoundBall from 'XrFrame/math/boundBall'
    import BoundBox from 'XrFrame/math/boundBox'
    import Vector3 from 'XrFrame/math/vector3'
    type Scene = import('XrFrame/core/Scene').default
    /**
     * `Geometry`中的Submesh定义。
     */
    export interface ISubMesh {
        /**
         * 子mesh的顶点偏移。
         */
        offset: number
        /**
         * 子mesh的顶点数量。
         */
        length: number
        /**
         * 子mesh的材质索引。
         */
        materialIndex: number
    }
    /**
     * 几何资源，用于定义渲染中的图元数据。
     */
    export default class Geometry {
        protected _scene: Scene
        /**
         * @internal
         */
        static readonly RAWLENGTH = 10
        /**
         * @internal
         */
        static readonly MAX_BONECOUNT = 96
        /**
         * @internal
         */
        /**
         * 获取IndexBuffer。
         */
        get indexBuffer(): import('XrFrame/kanata/lib/index').IndexBuffer
        /**
         * 获取VertexBuffer。
         */
        get vertexBuffer(): import('XrFrame/kanata/lib/index').VertexBuffer
        /**
         * 获取IndexData。
         * 这种类型的索引数据用于合批，只对于开启了`dynamicBatch`的Renderer有效。
         * 注意如果已经获取过`indexBuffer`，将无效。
         */
        get indexData(): import('XrFrame/kanata/lib/index').IndexData
        /**
         * 获取VertexData。
         * 这种类型的顶点数据用于合批，只对于开启了`dynamicBatch`的Renderer有效。
         * 注意如果已经获取过`vertexBuffer`，将无效。
         */
        get vertexData(): import('XrFrame/kanata/lib/index').VertexData
        /**
         * 该mesh是否有效，有些情况可能会造成这种现象，例如vertexLayout和buffer数量不匹配
         * 渲染时应该对该值做检查以防护
         * @internal
         */
        get valid(): boolean
        /**
         * 包围球，只读。
         */
        get boundBall(): BoundBall
        /**
         * 包围盒，只读。
         */
        get boundBox(): BoundBox
        /**
         * 获取所有的SubMesh，不要修改。
         * @internal
         */
        get subMeshes(): ISubMesh[]
        /**
         * 构造一个`Geometry`。
         */
        constructor(
            _scene: Scene,
            vertexLayout: Kanata.VertexLayout,
            vBuffer: ArrayBufferView,
            iBuffer: ArrayBufferView,
            indexType?: Kanata.EIndexType
        )
        /**
         * 更新VertexBuffer和IndexBuffer。
         * @internal
         */
        uploadBufferData(
            vBufferOffset: number,
            vBufferLength: number,
            iBufferOffset: number,
            iBufferLength: number
        ): void
        /**
         * 更新VertexBuffer。
         * 仅在获取了`vertexBuffer`后有效。
         */
        uploadVertexBuffer(offset: number, buffer: ArrayBufferView): void
        /**
         * 更新IndexBuffer。
         * 仅在获取了`indexBuffer`后有效。
         */
        uploadIndexBuffer(offset: number, buffer: ArrayBufferView): void
        /**
         * 获取当前mesh有多少subMesh
         */
        getSubMeshCount(): number
        /**
         * 获取指定序号的subMesh的索引起始点
         *
         * @returns {number} 索引起始点,返回-1代表SubMesh不存在
         */
        getIndiceStart(subMeshIndex: number): number
        /**
         * 获取指定序号的subMesh的索引长度
         *
         * @returns {number} 索引长度，返回-1代表SubMesh不存在
         */
        getIndiceLength(subMeshIndex: number): number
        /**
         * 获取指定序号的subMesh的材质序号
         *
         * @returns {number} 材质序号，返回-1代表subMesh不存在
         */
        getMaterialIndex(subMeshIndex: number): number
        /**
         * 获取VertexLayout。
         */
        getVertexLayout(): Kanata.VertexLayout
        /**
         * 修改subMesh。
         *
         * @param length 索引长度
         * @param offset 索引起始偏移
         */
        modifySubMesh(
            subMeshIndex: number,
            length: number,
            offset: number
        ): boolean
        /**
         * 增加subMesh。
         *
         * @param length 索引长度
         * @param offset 索引起始偏移
         */
        addSubMesh(length: number, offset: number, materialIndex?: number): void
        /**
         *  动态更新包围盒，默认会自动计算包围球。
         */
        setBoundBox(
            center: Vector3,
            size: Vector3,
            autoUpdateBall?: boolean
        ): void
        /**
         *  动态更新包围球。
         */
        setBoundBall(center: Vector3, radius: number): void
        /**
         * 获取第一个顶点Buffer原始数据，可能没有值。
         * @internal
         */
        /**
         * 获取索引Buffer原始数据。
         * @internal
         */
    }
    export {}
}

declare module 'XrFrame/assets/Material' {
    /**
     * Material.ts
     *
     *         * @Date    : 2022/3/24上午11:21:54
     */
    import { Kanata } from 'XrFrame/ext'
    import Effect, { IRenderStates } from 'XrFrame/assets/Effect'
    import Vector2 from 'XrFrame/math/vector2'
    import Vector3 from 'XrFrame/math/vector3'
    import Vector4 from 'XrFrame/math/vector4'
    import Matrix3 from 'XrFrame/math/matrix3'
    import Matrix4 from 'XrFrame/math/matrix4'
    type Scene = import('XrFrame/core/Scene').default
    /**
     * 材质资源，一般被代理到{@link XRMaterial}元素。
     */
    export default class Material {
        /**
         * @internal
         */
        get kanataMaterial(): import('XrFrame/kanata/lib/index').Material
        /**
         * @internal
         */
        get uniforms(): import('XrFrame/kanata/lib/index').UniformBlock
        set alphaMode(value: 'OPAQUE' | 'BLEND' | 'MASK')
        set alphaCutOff(value: number)
        /**
         * 透明物体需要大于`2500`！
         */
        get renderQueue(): number
        set renderQueue(value: number)
        constructor(_scene: Scene)
        /**
         * 通过效果初始化材质。
         */
        initByEffect(
            effect: Effect,
            defaultUniforms?: {
                [key: string]: ArrayLike<number> | number | Kanata.Texture
            }
        ): void
        /**
         * 获取一个Float
         */
        getFloat(key: string): number
        /**
         * 设置一个Float
         *
         * @returns 是否设置成功
         */
        setFloat(key: string, value: number): boolean
        /**
         * 设置一个Vector。
         *
         * @returns 是否设置成功。
         */
        setVector(key: string, value: Vector2 | Vector3 | Vector4): boolean
        /**
         * 获取一个Vector值的拷贝。
         */
        getVector(key: string): Vector2 | Vector3 | Vector4
        /**
         * 设置一个Matrix
         *
         * @returns 是否设置成功
         */
        setMatrix(key: string, value: Matrix3 | Matrix4): boolean
        /**
         * 获取一个Vector值的拷贝。
         */
        getMatrix(key: string): Matrix3 | Matrix4
        /**
         * 设置一张贴图。
         *
         * @returns 是否设置成功。
         */
        setTexture(key: string, value: Kanata.Texture): boolean
        /**
         * 设置一张贴图。
         *
         * @returns 是否设置成功。
         */
        setTextureAsset(key: string, assetId: string): boolean
        resetTexture(key: string): import('XrFrame/kanata/lib/index').Texture
        /**
         * 直接通过Backend纹理ID设置纹理，注意需要自己持有纹理引用。
         * @internal
         *
         * @returns 是否设置成功。
         */
        setFontTexture(key: string, id: number): boolean
        /**
         * 获取材质中已设置的贴图。
         */
        getTexture(key: string): Kanata.Texture
        /**
         * 设置渲染状态。
         * 只有标记了`useMaterialRenderStates`的Pass会受到影响
         */
        setRenderState<TKey extends keyof IRenderStates>(
            key: TKey,
            value: IRenderStates[TKey]
        ): boolean
        /**
         * 批量设置渲染状态。
         * 只有标记了`useMaterialRenderStates`的Pass会受到影响。
         */
        setRenderStates(states: IRenderStates): boolean
        /**
         * 清除渲染状态。
         * 清除材质的渲染状态，转而从effect中使用默认值。
         */
        clearRenderState<TKey extends keyof IRenderStates>(key: TKey): boolean
        /**
         * 批量清除渲染状态。
         * 清除材质的渲染状态，转而从effect中使用默认值。
         */
        clearRenderStates(states: { [key: string]: any }): boolean
        /**
         * 获取渲染状态。
         */
        getRenderState(key: string): number | boolean
        /**
         * 设置宏。
         */
        setMacro(key: string, value: boolean | number): void
        /**
         * 批量设置宏。
         */
        setMacros(marcos: { [key: string]: number | boolean }): void
        /**
         * 获取宏。
         */
        getMacro(key: string): boolean
        /**
         * 拷贝自身，生成一份新的材质数据。
         */
        clone(): Material
        /**
         * @internal
         */
        /**
         * @internal
         */
    }
    export {}
}

declare module 'XrFrame/assets/VideoTexture' {
    import { Kanata } from 'XrFrame/ext'
    type Scene = import('XrFrame/core/Scene').default
    /**
     * 视频纹理{@link VideoTexture}的创建参数。
     */
    export interface IVideoTextureOptions {
        /**
         * 视频地址。
         */
        src: string
        /**
         * 视频未加载成功时，可选的首帧图片地址。
         */
        placeHolder?: Kanata.IImage
        /**
         * 是否要在加载完毕后自动播放。
         */
        autoPlay?: boolean
        /**
         * 是否要循环播放。
         */
        loop?: boolean
        /**
         * 是否禁止音频，默认禁止。
         */
        abortAudio?: boolean
    }
    export enum EVideoState {
        Idle = 0,
        WaitPlay = 1,
        Playing = 2,
        Released = 3
    }
    /**
     * 视频纹理。
     */
    export default class VideoTexture {
        onEnd?: () => void
        get texture(): import('XrFrame/kanata/lib/index').Texture
        get width(): number
        get height(): number
        /**
         * @param onReady 创建成功时的回调。
         * @param onEnd 播放结束时的回调。
         */
        constructor(
            scene: Scene,
            options: IVideoTextureOptions,
            onReady: (vt: VideoTexture, error?: Error) => void,
            onEnd?: () => void
        )
        /**
         * @internal
         */
        /**
         * 播放视频。
         */
        play(first?: boolean): Promise<{
            width: number
            height: number
        }>
        /**
         * 从某处开始播放。
         *
         * @param pos 事件，单位为s
         */
        seek(pos: number): Promise<any>
        /**
         * 停止播放视频。
         */
        stop(): void
        /**
         * 释放视频。
         */
        release(): void
    }
    export {}
}

declare module 'XrFrame/assets/RenderTexture' {
    import { Kanata } from 'XrFrame/ext'
    type Scene = import('XrFrame/core/Scene').default
    export interface IRenderTarget {
        width: number
        height: number
        renderPass: Kanata.RenderPass
    }
    /**
     * `RenderTexture`资源参数接口。
     */
    export interface IRenderTextureOptions {
        width: number
        height: number
        isHDR?: boolean
    }
    /**
     * 渲染纹理组件，可作为{@link Camera.renderTarget}。
     */
    export default class RenderTexture {
        static IS(obj: any): obj is RenderTexture
        readonly isRenderTexture: boolean
        /**
         * 获取深度模板纹理。
         * @internal
         */
        get depthStencil(): import('XrFrame/kanata/lib/index').Texture
        /**
         * 获取第一个色彩纹理。
         * @internal
         */
        get texture(): import('XrFrame/kanata/lib/index').Texture
        /**
         * 获取深度纹理。
         * @internal
         */
        get depthTexture(): import('XrFrame/kanata/lib/index').Texture
        /**
         * 获取Backend实例。
         * @internal
         */
        get renderPass(): import('XrFrame/kanata/lib/index').RenderPass
        /**
         * 贴图高。
         */
        get height(): number
        /**
         * 贴图宽。
         */
        get width(): number
        get id(): number
        constructor(_scene: Scene, options: IRenderTextureOptions)
    }
    export {}
}

declare module 'XrFrame/assets/GLTFModel' {
    /**
     * GlTF.ts
     *
     *         * @Date    : 2022/4/1下午3:34:15
     */
    import NativeAnimation from 'XrFrame/animation/NativeAnimation'
    import Mesh from 'XrFrame/components/Mesh'
    import Element from 'XrFrame/core/Element'
    import { Kanata } from 'XrFrame/ext'
    import { GLTFRootLoaded } from 'XrFrame/loader/glTF/GLTFRootNode'
    import { GLTFTreeNode } from 'XrFrame/loader/glTF/scenes/GLTFNodesNode'
    type Scene = import('XrFrame/core/Scene').default
    /**
     * 收集glTF实例化过程中创建的对象，避免其GC。
     * @deprecated
     */
    export class GLTFInstanceResourceCollector {
        add(res: Kanata.IHandle): void
        release(): void
    }
    /**
     * 在{@link GLTFModel.instantiate}中传入的设置项。
     */
    export interface IGLTFModelOptions {
        /**
         * 是否投射阴影。
         */
        castShadow: boolean
        /**
         * 是否接受阴影。
         */
        receiveShadow: boolean
        /**
         * 是否**不**参与剔除。
         */
        neverCull: boolean
    }
    /**
     * 加载完毕的GLTF模型，可以在节点下创建{@link GLTF | GLTF组件}来将其实例化。
     */
    export default class GLTFModel {
        constructor(_scene: Scene, model: GLTFRootLoaded)
        /**
         * 使用GLB文件加载而成的buffer，来生成GLTF模型。
         */
        static createFromBuffer(
            scene: Scene,
            buffer: ArrayBuffer
        ): Promise<GLTFModel>
        /**
         * 实例化一个GLTF模型，将其加入到指定节点下，并返回一系列得到的物件。
         * @internal
         *
         * @returns subRoots GLTF场景的根节点对应的元素，因为一个GLTF可能有多个场景，所以可能有多个根节点。
         * @returns treeNodeMap GLTF节点对应到元素的映射表。
         * @returns animations 实例化产生的动画片段，需要手动将其加入{@link Animator}组件。
         * @returns meshes 实例化产生的所有{@link Mesh}组件。
         */
        instantiate(
            parent: Element,
            options: IGLTFModelOptions
        ): [
            subRoots: Element[],
            treeNodeMap: Map<GLTFTreeNode, Element>,
            animations: NativeAnimation[],
            meshes: Mesh[]
        ]
    }
    export {}
}

declare module 'XrFrame/assets/EnvData' {
    /**
     * EnvData.ts
     *
     *         * @Date    : 5/11/2022, 4:07:41 PM
     */
    import { Kanata } from 'XrFrame/ext'
    /**
     * `EnvData`的参数接口。
     */
    export interface IEnvDataOptions {
        /**
         * 天空盒。
         */
        skybox?: {
            /**
             * 是否只使用贴图的上半部分，一般在和`specular`共用贴图的时候为`true`。
             */
            half: boolean
            /**
             * 贴图。
             */
            map: Kanata.Texture
        }
        /**
         * 环境漫反射部分。
         */
        diffuse?: {
            /**
             * 球谐系数SH9。
             */
            coefficients: Float32Array
        }
        /**
         * 环境高光反射部分。
         */
        specular?: {
            /**
             * 贴图类型，目前只支持2D。
             */
            type: '2D'
            /**
             * 是否使用`rgbd`编码来。
             */
            rgbd: boolean
            /**
             * 是否使用mipmap。
             */
            mipmaps: boolean
            /**
             * 使用的mipmap级数。
             */
            mipmapCount?: number
            /**
             * 贴图。
             */
            map: Kanata.Texture
        }
    }
    /**
     * 环境数据资源，一般用[xr-frame-cli](https://github.com/wechat-miniprogram/xr-frame-cli)生成。
     */
    export default class EnvData {
        get useHalfSkyMap(): boolean
        get skyboxMap(): import('XrFrame/kanata/lib/index').Texture
        get hasDiffuse(): boolean
        get diffuseSH(): Float32Array
        get hasSpecular(): boolean
        get specularRGBD(): boolean
        get specularMipmaps(): boolean
        get specularMipmapCount(): number
        get specularMap(): import('XrFrame/kanata/lib/index').Texture
        constructor(options: IEnvDataOptions)
        destroy(): void
    }
}

declare module 'XrFrame/animation/Animation' {
    /**
     * Animation.ts
     *
     *         * @Date    : 6/17/2022, 3:17:12 PM
     */
    type Scene = import('XrFrame/core/Scene').default
    type Element = import('XrFrame/core/Element').default
    /**
     * 动画播放的方向，如果是`both`，则会在`loop`开启时的每次循环中自动反转。
     */
    export type TDirection = 'forwards' | 'backwards' | 'both'
    /**
     * 动画资源基类，被{@link Animator}使用，可以继承它来实现具体的动画。
     *
     * @template IData 动画初始化接受的数据。
     * @template IOptions 动画播放时接受的额外追加选项。
     */
    export default class Animation<IData = any, IOptions = any> {
        __DATA_TYPE: IData
        __OPTIONS_TYPE: IOptions
        /**
         * 动画所有的片段名字，必须在`onInit`中被初始化。
         */
        clipNames: string[]
        /**
         * 场景实例。
         */
        get scene(): import('XrFrame/core/Scene').default
        /**
         * @param _scene 场景实例。
         * @param data 初始化动画数据。
         */
        constructor(_scene: Scene, data: IData)
        /**
         * 动画初始化时执行的生命周期，只会执行一次。
         *
         * @param data 初始化动画数据。
         */
        onInit(data: IData): void
        /**
         * 动画开始播放时执行的生命周期。
         *
         * @param el 本次播放作用于的`element`，一个动画可能作用于多个`element`，可以在这里区分。
         * @param clipName 本次播放的片段名字。
         * @param options 本次播放时的附加选项。
         *
         * @returns 返回本次播放片段的参数，必须包括时长`duration`(s)，可选循环次数`loop`、延迟`delay`和方向`direction`。
         */
        onPlay(
            el: Element,
            clipName: string,
            options: IOptions
        ): {
            duration: number
            loop?: number
            delay?: number
            direction?: TDirection
        }
        /**
         * 在动画更新时执行的回调。
         *
         * @param el 本次播放作用于的`element`。
         * @param progress 播放进度，范围为线性的`0~1`。
         * @param reverse 本次播放是否反向。
         */
        onUpdate(el: Element, progress: number, reverse: boolean): void
        /**
         * 在动画暂停时执行的回调。
         *
         * @param el 本次播放作用于的`element`。
         */
        onPause(el: Element): void
        /**
         * 在动画从暂停状态唤醒时执行的回调。
         *
         * @param el 本次播放作用于的`element`。
         */
        onResume(el: Element): void
        /**
         * 在动画停止时执行的回调。
         *
         * @param el 本次播放作用于的`element`。
         */
        onStop(el: Element): void
    }
    export {}
}

declare module 'XrFrame/animation/KeyframeAnimation' {
    import Animation, { TDirection } from 'XrFrame/animation/Animation'
    type Element = import('XrFrame/core/Element').default
    /**
     * `Keyframe`动画数据的动画部分。
     */
    export interface IKeyframeAnimationInfo {
        /**
         * 指定动画使用的Keyframe。
         */
        keyframe: string
        /**
         * 动画长度(s)。
         */
        duration: number
        /**
         * 动画插值方式，详见{@link noneParamsEaseFuncs}和{@link useParamsEaseFuncs}。
         */
        ease: string
        /**
         * 如果是可以接受参数的插值方式，指定参数。
         */
        easeParams?: number[]
        /**
         * 循环次数，`0`为不循环，`-1`为永远循环。
         */
        loop?: number
        /**
         * 播放延迟。
         */
        delay?: number
        /**
         * 播放方向。
         */
        direction?: TDirection
    }
    /**
     * `Keyframe`动画数据的动画部分。
     */
    export interface IKeyframeAnimationData {
        /**
         * 关键帧定义部分，可以参考[basic-animation](https://mmbizwxaminiprogram-1258344707.cos.ap-guangzhou.myqcloud.com/xr-frame/doc/basic-animation.json)。
         *
         * `name`为关键帧名字。
         * `key`为`0~100`的进度。
         * `prop`为属性序列，其规则为`[componentName].[prop1].[prop2].[prop3]...`，但是有一些特殊的缩写：
         * `position`、`scale`、`rotation`是`transform`组件下对应的属性，`material.u_xxx`则是设置材质的uniform。
         * `prop`的值，可以是数字或者数字数组。
         */
        keyframe: {
            [name: string]: {
                [key: string]: {
                    [prop: string]: number | number[]
                }
            }
        }
        /**
         * 动画部分。
         */
        animation: {
            [name: string]: IKeyframeAnimationInfo
        }
    }
    export enum EKeyframeAnimationPropType {
        Default = 0,
        Math = 1,
        Uniform = 2,
        ComponentData = 3
    }
    /**
     * `Keyframe`动画的追加播放参数。
     */
    export interface IKeyframeAnimationOptions {
        /**
         * 改变插值方式。
         */
        ease?: string
        /**
         * 改变插值系数。
         */
        easeParams?: number[]
    }
    /**
     * 解析完的`Keyframe`部分实例，准备好数据以备正式播放。
     *
     * 开发者不需要关心，内部使用。
     */
    export class Keyframe {
        /**
         * @internal
         */
        get times(): number[]
        constructor(options: IKeyframeAnimationData['keyframe']['name'])
        start(el: Element): (p: number) => void
    }
    /**
     * `Keyframe`动画。
     */
    export default class KeyframeAnimation extends Animation<
        IKeyframeAnimationData,
        IKeyframeAnimationOptions
    > {
        onInit(data: IKeyframeAnimationData): void
        onPlay(
            el: Element,
            clipName: string,
            options: IKeyframeAnimationOptions
        ): IKeyframeAnimationInfo
        onUpdate(el: Element, progress: number, reverse: boolean): void
        onPause(el: Element): void
        onResume(el: Element): void
        onStop(el: Element): void
    }
    export {}
}

declare module 'XrFrame/assets/Atlas' {
    /**
     * Atlas.ts
     *
     *         * @Date    : 10/12/2022, 5:23:59 PM
     */
    import { Kanata } from 'XrFrame/ext'
    import Matrix3 from 'XrFrame/math/matrix3'
    import Vector4 from 'XrFrame/math/vector4'
    type Scene = import('XrFrame/core/Scene').default
    /**
     * `Atlas`的初始化参数类型。
     */
    export interface IAtlasOptions {
        /**
         * 图片。
         */
        image?: Kanata.IImage
        /**
         * 也可以直接传入一张纹理。
         */
        texture?: Kanata.Texture
        /**
         * 帧定义，若不指定`uv`则会自动按比例计算。
         */
        frames: {
            [key: string]: {
                /**
                 * 帧的区块信息。
                 */
                frame: {
                    x: number
                    y: number
                    w: number
                    h: number
                }
                /**
                 * 会自动生成，开发者无需关心。
                 *
                 * @hidden
                 */
                uvMatrix?: Matrix3
                /**
                 * 会自动生成，开发者无需关心。
                 *
                 * @hidden
                 */
                uvST?: Vector4
            }
        }
        /**
         * 原信息，主要定义图片尺寸。
         */
        meta: {
            size: {
                w: number
                h: number
            }
        }
    }
    /**
     * 图集资源创建参数。
     */
    export interface IAtlasCreationOptions {
        /**
         * 单元宽度。
         */
        cellWidth?: number
        /**
         * 单元高度。
         */
        cellHeight?: number
        /**
         * 单元间的间隙。
         */
        space?: number
        /**
         * 每行有多少帧（单元）。
         */
        framesPerLine: number
        /**
         * 需要从哪一帧开始。
         */
        frameStart?: number
        /**
         * 需要几帧。
         */
        frameCount?: number
    }
    /**
     * 图集资源。
     * @version 2.27.1
     *
     * 一般通过{@link AtlasLoader}加载自动生成。
     * 推荐使用[Shoebox](https://www.renderhjs.net/shoebox/)等工具生成。
     */
    export default class Atlas {
        isAtlas: boolean
        protected _AUTO_ID: number
        protected _image: Kanata.IImage
        protected _texture: Kanata.Texture
        protected _frames: IAtlasOptions['frames']
        protected _meta: IAtlasOptions['meta']
        protected _updatable: boolean
        protected _root: string
        protected _area: number
        protected _needReBuild: boolean
        /**
         * 根据宽高和行数、列数来创建一个空的图集。
         * 这个图集将被行列分成若干个格子帧，开发者可以根据实际状况去使用`updateFrame`更新这些格子。
         * 自动生成的帧的名字为`${row}${col}`，比如第一行第一列为`'11'`。
         *
         * @param onUpdate 初始化时的回调，可以用于一开始绘制图像
         */
        static CREATE_FROM_GRIDS(
            scene: Scene,
            options: {
                width: number
                height: number
                rows: number
                cols: number
                space?: number
            },
            onUpdate?: (
                texture: Kanata.Texture,
                region: {
                    col: number
                    row: number
                    x: number
                    y: number
                    w: number
                    h: number
                },
                frameName: string
            ) => void
        ): Atlas
        /**
         * 根据纹理和配置，来通过纹理创建一个不可修改的图集。通常用于精灵动画。
         * 这个图集将被行列分成若干个格子帧，每一帧的名字为`0`、`1`、`2`......
         */
        static CREATE_FROM_TEXTURE(
            scene: Scene,
            texture: Kanata.Texture,
            options: IAtlasCreationOptions
        ): Atlas
        /**
         * 获取元信息。
         */
        get meta(): {
            size: {
                w: number
                h: number
            }
        }
        /**
         * 获取帧集合。
         */
        get frames(): {
            [key: string]: {
                /**
                 * 帧的区块信息。
                 */
                frame: {
                    x: number
                    y: number
                    w: number
                    h: number
                }
                /**
                 * 会自动生成，开发者无需关心。
                 *
                 * @hidden
                 */
                uvMatrix?: Matrix3
                /**
                 * 会自动生成，开发者无需关心。
                 *
                 * @hidden
                 */
                uvST?: Vector4
            }
        }
        /**
         * 获取整体的纹理。
         */
        get texture(): import('XrFrame/kanata/lib/index').Texture
        /**
         * 构建一个图集。
         *
         * @param options 初始化参数。
         */
        constructor(_scene: Scene, options: IAtlasOptions)
        /**
         * 获取某一帧的数据。
         */
        getFrame(frameName: string): {
            x: number
            y: number
            w: number
            h: number
        }
        /**
         * 获取某一帧的uv变换矩阵。
         */
        getUVMatrix(frameName: string): Matrix3
        protected _buildUVMatrix(frame: {
            x: number
            y: number
            w: number
            h: number
        }): Matrix3
        /**
         * 获取某一帧的uvST。
         * [sx, sy, tx, ty]。
         */
        getUVST(frameName: string): Vector4
        protected _buildUVST(frame: {
            x: number
            y: number
            w: number
            h: number
        }): Vector4
        /**
         * 更新某一frame，通过`onUpdate`方法参数中的`texture`和`region`来更新上此帧所占据区域内的图像。
         */
        updateFrame(
            frameName: string,
            onUpdate: (
                texture: Kanata.Texture,
                region: {
                    x: number
                    y: number
                    w: number
                    h: number
                },
                frameName: string
            ) => void
        ): void
    }
    export {}
}

declare module 'XrFrame/assets/PostProcess' {
    /**
     * PostProcess.ts
     *
     *         * @Date    : 10/14/2022, 4:34:55 PM
     */
    type Scene = import('XrFrame/core/Scene').default
    /**
     * 后处理资源初始化参数。
     */
    export interface IPostProcessOptions {
        /**
         * 类型，目前支持的类型请见[内置后处理资源](https://developers.weixin.qq.com/miniprogram/dev/component/xr-frame/builtin/post-process)。
         */
        type: string
        /**
         * 是否开启HDR。
         */
        isHDR?: boolean
        /**
         * 对应类型的数据。
         */
        data?: {
            [key: string]: any
        }
    }
    /**
     * 后处理资源。
     *
     * 一般由{@link AssetPostProcess}加载。
     */
    export default class PostProcess {
        /**
         * 类型。
         */
        get type(): string
        /**
         * 是否开启了HDR。
         */
        get isHDR(): boolean
        /**
         * 数据，可以修改。
         */
        get data(): {
            [key: string]: any
        }
        constructor(_scene: Scene, options: IPostProcessOptions)
    }
    export {}
}

declare module 'XrFrame/assets/factories' {
    /**
     * factories.ts
     *
     *         * @Date    : 2022/3/23下午4:04:18
     */
    import Scene from 'XrFrame/core/Scene'
    import Effect from 'XrFrame/assets/Effect'
    import Geometry from 'XrFrame/assets/Geometry'
    import Material from 'XrFrame/assets/Material'
    /**
     * @internal
     */
    export function getAssetFactory<T = any>(
        type: string,
        id: string
    ): (scene: Scene) => T
    /**
     * 注册`Geometry`资源。
     */
    export const registerGeometry: (
        id: string,
        factory: (scene: Scene) => Geometry
    ) => void
    /**
     * 注册`Effect`资源。
     */
    export const registerEffect: (
        id: string,
        factory: (scene: Scene) => Effect
    ) => void
    /**
     * 注册`Texture`资源。
     */
    export const registerTexture: (
        id: string,
        factory: (scene: Scene) => import('XrFrame/kanata/lib/index').Texture
    ) => void
    /**
     * 注册`TextureCube`资源。
     */
    export const registerTextureCube: (
        id: string,
        factory: (scene: Scene) => import('XrFrame/kanata/lib/index').Texture
    ) => void
    /**
     * 注册`VertexDataDescriptor`资源。
     */
    export const registerVertexDataDesc: (
        id: string,
        factory: (
            scene: Scene
        ) => import('XrFrame/kanata/lib/index').VertexDataDescriptor
    ) => void
    /**
     * 注册`UniformDescriptor`资源。
     */
    export const registerUniformDesc: (
        id: string,
        factory: (
            scene: Scene
        ) => import('XrFrame/kanata/lib/index').UniformDescriptor
    ) => void
    /**
     * 注册`VertexLayout`资源。
     */
    export const registerVertexLayout: (
        id: string,
        factory: (
            scene: Scene
        ) => import('XrFrame/kanata/lib/index').VertexLayout
    ) => void
    /**
     * 注册`Material`资源。
     */
    export const registerMaterial: (
        id: string,
        factory: (scene: Scene) => Material
    ) => void
}

declare module 'XrFrame/assets/easeFunctions' {
    /**
     * easeFunctions.ts
     *
     *         * @Date    : 6/21/2022, 11:24:27 AM
     */
    type TEaseFunction = (progress: number) => number
    /**
     * 可以自定义参数的插值函数。
     */
    export const useParamsEaseFuncs: {
        /**
         * 二次贝塞尔曲线。
         *
         * @param params p1x, p1y, p2x, p2y。
         * @returns 最终的插值函数。
         */
        'cubic-bezier': (
            times: number[],
            params: number[]
        ) => (x: number) => number
        /**
         * 步进插值曲线。
         *
         * @param params 一个参数，总步数。
         * @returns 最终的插值函数。
         */
        steps: (times: number[], params: number[]) => (x: number) => number
    }
    /**
     * 不需要自定义参数的一些内置插值曲线。
     */
    export const noneParamsEaseFuncs: {
        linear: (x: any) => any
        'ease-in': (x: number) => number
        'ease-out': (x: number) => number
        'ease-in-out': (x: number) => number
        'ease-in-quad': (x: any) => number
        'ease-out-quad': (x: any) => number
        'ease-in-out-quad': (x: any) => number
        'ease-in-cubic': (x: any) => number
        'ease-out-cubic': (x: any) => number
        'ease-in-out-cubic': (x: any) => number
        'ease-in-quart': (x: any) => number
        'ease-out-quart': (x: any) => number
        'ease-in-out-quart': (x: any) => number
        'ease-in-quint': (x: any) => number
        'ease-out-quint': (x: any) => number
        'ease-in-out-quint': (x: any) => number
        'ease-in-sine': (x: any) => number
        'ease-out-sine': (x: any) => number
        'ease-in-out-sine': (x: any) => number
        'ease-in-expo': (x: any) => number
        'ease-out-expo': (x: any) => number
        'ease-in-out-expo': (x: any) => number
        'ease-in-circ': (x: any) => number
        'ease-out-circ': (x: any) => number
        'ease-in-out-circ': (x: any) => number
        'ease-in-back': (x: any) => number
        'ease-out-back': (x: any) => number
        'ease-in-out-back': (x: any) => number
        'ease-in-elastic': (x: any) => number
        'ease-out-elastic': (x: any) => number
        'ease-in-out-elastic': (x: any) => number
        'ease-in-bounce': (x: any) => number
        'ease-out-bounce': TEaseFunction
        'ease-in-out-bounce': (x: any) => number
    }
    export {}
}

declare module 'XrFrame/math/vector2' {
    export default class Vector2 {
        /**
         * x值
         *
         * @type {number}
         * @memberof Vector2
         */
        get x(): number
        set x(val: number)
        /**
         * y值
         *
         * @type {number}
         * @memberof Vector2
         */
        get y(): number
        set y(val: number)
        /**
         * 零向量，不要对该对象进行修改
         *
         * @readonly
         * @static
         * @type {V3ReadOnly}
         * @memberof Vector3
         */
        static readonly ZERO: Vector2
        /**
         * 一向量，不要对该对象进行修改
         *
         * @readonly
         * @static
         * @type {V3ReadOnly}
         * @memberof Vector3
         */
        static readonly ONE: Vector2
        _raw: Float32Array
        /**
         * 使用一个数组创建
         * 此操作会拷贝一份数组
         *
         * @static
         * @param {number[]} array 数据源，长度必须为2，否则会抛出异常
         * @returns {Vector2} 创建出来的向量
         * @memberof Vector2
         */
        static createFromArray(array: number[]): Vector2
        /**
         * 使用某个已有的typedArray创建
         * 此操作不会拷贝数据，而是在原来的内存区域上操作
         *
         * @static
         * @param {Float32Array} array 数据源
         * @param {number} [offset=0] 数据源中的偏移
         * @returns {Vector2} 创建出来的向量
         * @memberof Vector2
         */
        static createFromTypedArray(
            array: Float32Array,
            offset?: number
        ): Vector2
        /**
         * 返回向量数据
         *
         * @returns {number[]} 矩阵数据，以JSArray返回
         * @memberof Vector2
         */
        toArray(): number[]
        /**
         * 判断与目标向量的值是否相等
         *
         * @param {V2ReadOnly} v 目标向量
         * @returns {boolean} 是否相等，这里误差小于10^-6视为相等
         * @memberof Vector2
         */
        equal(v: Vector2): boolean
        /**
         * 拷贝目标向量的值到该向量
         *
         * @param {V2ReadOnly} val 目标向量
         * @returns {Vector2} 自身
         * @memberof Vector2
         */
        set(val: Vector2): Vector2
        /**
         * 设置向量的值
         *
         * @param {number} x x值
         * @param {number} y y值
         * @returns {Vector2} 自身
         * @memberof Vector2
         */
        setValue(x: number, y: number): Vector2
        /**
         * 向量加法
         *
         * @param {V2ReadOnly} v 目标向量
         * @param {Vector2} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Vector2} 计算结果
         * @memberof Vector2
         */
        add(v: Vector2, dst?: Vector2): Vector2
        /**
         * 向量减法
         *
         * @param {V2ReadOnly} v 目标向量
         * @param {Vector2} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Vector2} 计算结果
         * @memberof Vector2
         */
        sub(v: Vector2, dst?: Vector2): Vector2
        /**
         * 向量归一化，如该向量为零向量，则结果依然为零向量
         *
         * @param {Vector2} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Vector2} 计算结果
         * @memberof Vector2
         */
        normalize(dst?: Vector2): Vector2
        /**
         * 向量缩放
         *
         * @param {number} f 缩放比
         * @param {Vector2} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Vector2} 计算结果
         * @memberof Vector2
         */
        scale(f: number, dst?: Vector2): Vector2
        /**
         * 在该向量与目标向量之间计算插值
         *
         * @param {V2ReadOnly} v 目标向量
         * @param {number} f 插值系数
         * @param {Vector2} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Vector2} 计算结果
         * @memberof Vector2
         */
        lerp(v: Vector2, f: number, dst?: Vector2): Vector2
        /**
         * 取反
         * @returns
         */
        negate(): this
        /**
         * 向量点乘
         *
         * @param {V2ReadOnly} v 目标向量
         * @returns {number} 计算结果
         * @memberof Vector2
         */
        dot(v: Vector2): number
        /**
         * 向量的模
         *
         * @returns {number} 计算结果
         * @memberof Vector2
         */
        length(): number
        /**
         * 拷贝该向量
         *
         * @returns {Vector2} 拷贝出来的对象
         * @memberof Vector2
         */
        clone(): Vector2
        /**
         * 是否为零向量
         *
         * @returns {boolean}
         * @memberof Vector2
         */
        isZero(): boolean
        /**
         * 获取向量旋转角，以角度表示
         *
         * @returns {number} 旋转角，以角度表示
         * @memberof Vector2
         */
        getAngle(): number
        setArray(value: ArrayLike<number>, offset?: number): Vector2
    }
}

declare module 'XrFrame/math/vector3' {
    import QuatReadOnly from 'XrFrame/math/quaternion'
    import M4ReadOnly from 'XrFrame/math/matrix4'
    export default class Vector3 {
        /**
         * x值
         *
         * @type {number}
         * @memberof Vector3
         */
        get x(): number
        set x(val: number)
        /**
         * y值
         *
         * @type {number}
         * @memberof Vector3
         */
        get y(): number
        set y(val: number)
        /**
         * z值
         *
         * @type {number}
         * @memberof Vector3
         */
        get z(): number
        set z(val: number)
        /**
         * 零向量，不要对该对象进行修改
         *
         * @readonly
         * @static
         * @type {Vector3}
         * @memberof Vector3
         */
        static readonly ZERO: Vector3
        /**
         * 一向量，不要对该对象进行修改
         *
         * @readonly
         * @static
         * @type {Vector3}
         * @memberof Vector3
         */
        static readonly ONE: Vector3
        /**
         * 上方向，不要对该对象进行修改
         *
         * @static
         * @type {Vector3}
         * @memberof Vector3
         */
        static readonly Up: Vector3
        /**
         * 前方向，基于左手坐标系，不要对该对象进行修改
         *
         * @static
         * @type {Vector3}
         * @memberof Vector3
         */
        static readonly ForwardLH: Vector3
        _raw: Float32Array
        /**
         * 使用一个数组创建
         * 此操作会拷贝一份数组
         *
         * @static
         * @param {number[]} array 数据源，长度必须为3，否则会抛出异常
         * @returns {Vector3} 创建出来的向量
         * @memberof Vector3
         */
        static createFromArray(array: number[]): Vector3
        /**
         * 使用某个已有的typedArray创建
         * 此操作不会拷贝数据，而是在原来的内存区域上操作
         *
         * @static
         * @param {Float32Array} array 数据源
         * @param {number} [offset=0] 数据源中的偏移
         * @returns {Vector3}
         * @memberof Vector3
         */
        static createFromTypedArray(
            array: Float32Array,
            offset?: number
        ): Vector3
        /**
         * 使用四元数进行向量旋转
         *
         * @static
         * @param {Vector3} source 源向量
         * @param {QuatReadOnly} rotation 用于旋转的四元数
         * @param {Vector3} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Vector3} 计算结果
         * @memberof Vector3
         */
        static transformQuat(
            source: Vector3,
            rotation: QuatReadOnly,
            dst?: Vector3
        ): Vector3
        static transformCoordinate(
            coordinate: Vector3,
            transform: M4ReadOnly,
            dst?: Vector3
        ): Vector3
        /**
         * 返回向量数据
         *
         * @returns {number[]} 矩阵数据，以JSArray返回
         * @memberof Vector3
         */
        toArray(): [number, number, number]
        /**
         * 判断与目标向量的值是否相等
         *
         * @param {Vector3} v 目标向量
         * @returns {boolean} 是否相等，这里误差小于10^-6视为相等
         * @memberof Vector3
         */
        equal(v: Vector3): boolean
        /**
         * 拷贝目标向量的值到该向量
         *
         * @param {Vector3} val 目标向量
         * @returns {Vector3} 自身
         * @memberof Vector3
         */
        set(v: Vector3): Vector3
        /**
         * 设置向量的值
         *
         * @param {number} x x
         * @param {number} y y
         * @param {number} z z
         * @returns {Vector3} 自身
         * @memberof Vector3
         */
        setValue(x: number, y: number, z: number): Vector3
        setFromArray(xyz: number[]): Vector3
        /**
         * 向量加法
         *
         * @param {Vector3} v 目标向量
         * @param {Vector3} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Vector3} 计算结果
         * @memberof Vector3
         */
        add(v: Vector3, dst?: Vector3): Vector3
        /**
         * 向量减法
         *
         * @param {Vector3} v 目标向量
         * @param {Vector3} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Vector3} 计算结果
         * @memberof Vector3
         */
        sub(v: Vector3, dst?: Vector3): Vector3
        /**
         * 向量叉乘
         *
         * @param {Vector3} v 目标向量
         * @param {Vector3} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Vector3} 计算结果
         * @memberof Vector3
         */
        cross(v: Vector3, dst?: Vector3): Vector3
        /**
         * 向量归一化
         *
         * @param {Vector3} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Vector3} 计算结果
         * @memberof Vector3
         */
        normalize(dst?: Vector3): Vector3
        /**
         * 向量缩放
         *
         * @param {number} f 缩放比
         * @param {Vector3} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Vector3} 计算结果
         * @memberof Vector3
         */
        scale(f: number, dst?: Vector3): Vector3
        /**
         * 向量缩放
         *
         * @param {number} x x缩放比
         * @param {number} y y缩放比
         * @param {number} z z缩放比
         * @param {Vector3} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Vector3} 计算结果
         * @memberof Vector3
         */
        scaleXYZ(x: number, y: number, z: number, dst?: Vector3): Vector3
        /**
         * 在该向量与目标向量之间计算插值
         *
         * @param {Vector3} v 目标向量
         * @param {number} f 插值系数
         * @param {Vector3} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Vector3} 计算结果
         * @memberof Vector3
         */
        lerp(v: Vector3, f: number, dst?: Vector3): Vector3
        /**
         * 取反
         * @returns
         */
        negate(): this
        /**
         * 向量点乘
         *
         * @param {Vector3} v 目标向量
         * @returns {number} 计算结果
         * @memberof Vector3
         */
        dot(v: Vector3): number
        /**
         * 向量的模
         *
         * @returns {number} 计算结果
         * @memberof Vector3
         */
        length(): number
        /**
         * 拷贝该向量
         *
         * @returns {Vector3} 拷贝出来的对象
         * @memberof Vector3
         */
        clone(): Vector3
        /**
         * 是否为零向量
         *
         * @returns {boolean}
         * @memberof Vector3
         */
        isZero(): boolean
        /**
         * 获取到目标点的距离
         *
         * @param {Vector3} p 目标点
         * @returns {number} 计算结果
         * @memberof Vector3
         */
        distanceTo(p: Vector3): number
        /**
         * 获取到目标点的角度
         *
         * @param {Vector3} location 目标点
         * @returns {number} 计算结果
         * @memberof Vector3
         */
        angleTo(location: Vector3, dst?: Vector3): Vector3
        setFromMatrixColumn(m: M4ReadOnly, index: number): Vector3
        fromArray(array: Float32Array, offset: number): Vector3
        setFromMatrixScale(m: M4ReadOnly): Vector3
        /**
         * create by janzen
         * Sets this vector to the position elements of the transformation matrix
         */
        setFromMatrixPosition(worldMatrix: M4ReadOnly): Vector3
        /**
         * create by janzen
         * Multiplies this vector (with an implicit 1 in the 4th dimension) and m, and divides by perspective.
         */
        applyMatrix4(m: M4ReadOnly): Vector3
        /**
         * create by roamye
         * Multiplies this vector (with an implicit 1 in the 4th dimension) and m, and divides by perspective.
         */
        applyMatrix4Raw(m: Float32Array): this
        applyQuaternion(q: QuatReadOnly): this
        /**
         * create by janzen
         * Transforms the direction of this vector by a matrix (the upper left 3 x 3 subset of a m) and then normalizes the result.
         */
        transformDirection(m: M4ReadOnly): Vector3
        /**
         * create by roamye
         * Transforms the direction of this vector by a matrix (the upper left 3 x 3 subset of a m) and then normalizes the result.
         */
        transformDirectionRaw(raw: Float32Array): Vector3
        /**
         * created by shanexyzhou
         * 从物理引擎内的RawVec3f生成Vector3
         */
        static fromPhysics(v: any): Vector3
        fromPhysics(v: any): Vector3
        static Phys3D?: typeof phys3D
        static clearPhysicsPool(): void
        /**
         * created by shanexyzhou
         * 生成物理引擎内的RawVec3f
         */
        toPhysics(): any
        setArray(value: ArrayLike<number>, offset?: number): Vector3
        print(): void
    }
    export class Vector3ReadOnly extends Vector3 {
        get x(): number
        set x(v: number)
        get y(): number
        set y(v: number)
        get z(): number
        set z(v: number)
        constructor(array?: Float32Array, offset?: number)
        set(): this
        setValue(): this
    }
}

declare module 'XrFrame/math/vector4' {
    export default class Vector4 {
        /**
         * x值
         *
         * @type {number}
         * @memberof Vector4
         */
        get x(): number
        set x(val: number)
        /**
         * y值
         *
         * @type {number}
         * @memberof Vector4
         */
        get y(): number
        set y(val: number)
        /**
         * z值
         *
         * @type {number}
         * @memberof Vector4
         */
        get z(): number
        set z(val: number)
        /**
         * w值
         *
         * @type {number}
         * @memberof Vector4
         */
        get w(): number
        set w(val: number)
        /**
         * 零向量，不要对该对象进行修改
         *
         * @static
         * @readonly
         * @type {Vector4}
         * @memberof Vector4
         */
        static readonly ZERO: Vector4
        /**
         * 一向量，不要对该对象进行修改
         *
         * @readonly
         * @static
         * @type {V3ReadOnly}
         * @memberof Vector3
         */
        static readonly ONE: Vector4
        _raw: Float32Array
        /**
         * 使用一个数组创建
         * 此操作会拷贝一份数组
         *
         * @static
         * @param {number[]} array 数据源，长度必须为4，否则会抛出异常
         * @returns {Vector4} 创建出来的向量
         * @memberof Vector4
         */
        static createFromArray(array: number[]): Vector4
        /**
         * 使用某个已有的typedArray创建
         * 此操作不会拷贝数据，而是在原来的内存区域上操作
         *
         * @static
         * @param {Float32Array} array 数据源
         * @param {number} [offset=0] 数据源中的偏移
         * @returns {Vector4}
         * @memberof Vector4
         */
        static createFromTypedArray(
            array: Float32Array,
            offset?: number
        ): Vector4
        /**
         * 返回向量数据
         *
         * @returns {number[]} 矩阵数据，以JSArray返回
         * @memberof Vector4
         */
        toArray(): number[]
        /**
         * 判断与目标向量的值是否相等
         *
         * @param {Vector4} v 目标向量
         * @returns {boolean} 是否相等，这里误差小于10^-6视为相等
         * @memberof Vector4
         */
        equal(v: Vector4): boolean
        /**
         * 拷贝目标向量的值到该向量
         *
         * @param {Vector4} val 目标向量
         * @returns {Vector4} 自身
         * @memberof Vector4
         */
        set(v: Vector4): Vector4
        /**
         * 设置向量的值
         *
         * @param {number} x x值
         * @param {number} y y值
         * @param {number} z z值
         * @param {number} w w值
         * @returns {Vector4} 自身
         * @memberof Vector4
         */
        setValue(x: number, y: number, z: number, w: number): Vector4
        /**
         * 向量加法
         *
         * @param {Vector4} v 目标向量
         * @param {Vector4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Vector4} 计算结果
         * @memberof Vector4
         */
        add(v: Vector4, dst?: Vector4): Vector4
        /**
         * 向量减法
         *
         * @param {Vector4} v 目标向量
         * @param {Vector4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Vector4} 计算结果
         * @memberof Vector4
         */
        sub(v: Vector4, dst?: Vector4): Vector4
        /**
         * 向量缩放
         *
         * @param {number} f 缩放比
         * @param {Vector4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Vector4} 计算结果
         * @memberof Vector4
         */
        scale(f: number, dst?: Vector4): Vector4
        /**
         * 在该向量与目标向量之间计算插值
         *
         * @param {Vector4} v 目标向量
         * @param {number} f 插值系数
         * @param {Vector4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Vector4} 计算结果
         * @memberof Vector4
         */
        lerp(v: Vector4, f: number, dst?: Vector4): Vector4
        /**
         * 取反
         * @returns
         */
        negate(): this
        /**
         * 向量点乘
         *
         * @param {Vector4} v 目标向量
         * @returns {number} 计算结果
         * @memberof Vector4
         */
        dot(v: Vector4): number
        /**
         * 是否为零向量
         *
         * @returns {boolean}
         * @memberof Vector4
         */
        isZero(): boolean
        /**
         * 拷贝该向量
         *
         * @returns {Vector4} 拷贝出来的对象
         * @memberof Vector4
         */
        clone(): Vector4
        setArray(value: ArrayLike<number>, offset?: number): Vector4
    }
}

declare module 'XrFrame/math/quaternion' {
    import Vector3 from 'XrFrame/math/vector3'
    import V3ReadOnly from 'XrFrame/math/vector3'
    import QuatReadOnly from 'XrFrame/math/quaternion'
    import M4ReadOnly from 'XrFrame/math/matrix4'
    /**
     * @public
     */
    export default class Quaternion {
        set x(val: number)
        /**
         * y值
         *
         * @type {number}
         * @memberof Quaternion
         */
        get y(): number
        set y(val: number)
        /**
         * z值
         *
         * @type {number}
         * @memberof Quaternion
         */
        get z(): number
        set z(val: number)
        /**
         * w值
         *
         * @type {number}
         * @memberof Quaternion
         */
        get w(): number
        set w(val: number)
        /**
         * 默认四元数，不要对该对象进行修改
         *
         * @readonly
         * @static
         * @type {QuatReadOnly}
         * @memberof Quaternion
         */
        static readonly DEFAULT: QuatReadOnly
        _raw: Float32Array
        /**
         * 从旋转矩阵创建
         *
         * @static
         * @param {Matrix4} mat
         * @param {Quaternion} [dst]
         * @returns {Quaternion}
         * @memberof Quaternion
         */
        static createFromMatrix4(mat: M4ReadOnly, dst?: Quaternion): Quaternion
        /**
         * 从轴向旋转创建
         *
         * @static
         * @param {V3ReadOnly} axis 旋转轴
         * @param {number} rad 旋转幅度
         * @param {Quaternion} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Quaternion} 计算结果
         * @memberof Quaternion
         */
        static createFromAxisAngle(
            axis: V3ReadOnly,
            rad: number,
            dst?: Quaternion
        ): Quaternion
        /**
         * 由视角方向创建四元数
         *
         * @static
         * @param {V3ReadOnly} forward 前方向
         * @param {V3ReadOnly} up 上方向
         * @param {Quaternion} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Quaternion} 计算结果
         * @memberof Quaternion
         */
        static lookRotation(
            forward: V3ReadOnly,
            up: V3ReadOnly,
            dst?: Quaternion
        ): Quaternion
        /**
         * 使用数值创建
         *
         * @static
         * @param {number} x x
         * @param {number} y y
         * @param {number} z z
         * @param {number} w w
         * @returns {Quaternion} 创建出来的四元数
         * @memberof Quaternion
         */
        static createFromNumber(
            x: number,
            y: number,
            z: number,
            w: number
        ): Quaternion
        /**
         * 使用一个数组创建
         * 此操作会拷贝一份数组
         *
         * @static
         * @param {number[]} array 数据源，长度必须为4，否则会抛出异常
         * @returns {Quaternion}
         * @memberof Quaternion
         */
        static createFromArray(array: number[]): Quaternion
        /**
         * 使用某个已有的typedArray创建
         * 此操作不会拷贝数据，而是在原来的内存区域上操作
         *
         * @static
         * @param {Float32Array} array 数据源
         * @param {number} [offset=0] 数据源中的偏移
         * @returns {Quaternion}
         * @memberof Quaternion
         */
        static createFromTypedArray(
            array: Float32Array,
            offset?: number
        ): Quaternion
        /**
         * 通过俩个向量创建四元数
         * @param vFrom
         * @param vTo
         * @returns
         */
        static createFromUnitVectors(vFrom: Vector3, vTo: Vector3): QuatReadOnly
        /**
         * 拷贝目标四元数的值到自身
         *
         * @param {Quaternion} quat 目标四元数
         * @returns {Quaternion} 自身
         * @memberof Quaternion
         */
        set(quat: Quaternion): Quaternion
        /**
         * 设置四元数的值
         *
         * @param {number} x
         * @param {number} y
         * @param {number} z
         * @param {number} w
         * @returns {Quaternion} 自身
         * @memberof Quaternion
         */
        setValue(x: number, y: number, z: number, w: number): Quaternion
        /**
         * 球面插值
         *
         * @param {Quaternion} right 目标四元数
         * @param {number} t 插值系数，越接近 1 则结果越接近目标
         * @param {Quaternion} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Quaternion} 计算结果
         * @memberof Quaternion
         */
        slerp(right: QuatReadOnly, t: number, dst?: Quaternion): Quaternion
        /**
         * 四元数反转
         *
         * @param {Quaternion} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Quaternion} 计算结果
         * @memberof Quaternion
         */
        invert(dst?: Quaternion): Quaternion
        /**
         * 四元数相加
         *
         * @param {Quaternion} quat 目标四元数
         * @param {Quaternion} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Quaternion} 计算结果
         * @memberof Quaternion
         */
        add(quat: QuatReadOnly, dst?: Quaternion): Quaternion
        /**
         * 四元数相减
         *
         * @param {Quaternion} quat 目标四元数
         * @param {Quaternion} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Quaternion} 计算结果
         * @memberof Quaternion
         */
        sub(quat: QuatReadOnly, dst?: Quaternion): Quaternion
        /**
         * 四元数相乘
         *
         * @param {Quaternion} quat 目标四元数
         * @param {Quaternion} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Quaternion} 计算结果
         * @memberof Quaternion
         */
        multiply(quat: QuatReadOnly, dst?: Quaternion): Quaternion
        premultiply(q: QuatReadOnly): QuatReadOnly
        /**
         * 点乘
         * @param q
         */
        dot(q: QuatReadOnly): number
        length(): number
        normalize(): this
        setFromUnitVectors(vFrom: any, vTo: any): this
        setFromYawRollPitch(yaw: number, roll: number, pitch: number): void
        setFromEulerAngles(euler: Vector3): void
        /**
         * 相对角度
         * @param q
         */
        angleTo(q: QuatReadOnly): number
        /**
         * 转向对应的角度
         * @param q
         * @param step
         */
        rotateTowards(q: any, step: any): QuatReadOnly
        /**
         * 拷贝四元数
         *
         * @returns {Quaternion} 拷贝后的对象
         * @memberof Quaternion
         */
        clone(): Quaternion
        /**
         * 四元数是否为默认四元数（表示零旋转）
         *
         * @returns {boolean}
         * @memberof Quaternion
         */
        isDefault(): boolean
        /**
         * 将该四元数转换成欧拉角，x代表Pitch,y代表Yaw,z代表Roll
         * 旋转的顺序为YXZ
         *
         * @notation 2022.6.1 by shanexyzhou
         * 这个函数有bug：
         * 正确转换：[ -0.7, 0, 0, 0.7 ] → [ x: -1.5707963, y: 0, z: 0 ]
         * 目前结果：[ x: -1.5707963, y: -1.5707963, z: 1.5707963 ] (错误)
         * 待修复，目前先别用这个函数。
         *
         * @param {Vector3} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Vector3} 计算结果
         * @memberof Quaternion
         */
        toEulerAngles(dst?: Vector3): Vector3
        /**
         * 判断与目标四元数的值是否相等
         *
         * @param {QuatReadOnly} quat 目标四元数
         * @returns {boolean}
         * @memberof Quaternion
         */
        equal(quat: QuatReadOnly): boolean
        /**
         * created by shanexyzhou
         * 从物理引擎内的RawQuaternion生成Quaternion
         */
        static fromPhysics(v: phys3D.RawQuaternion): Quaternion
        fromPhysics(v: phys3D.RawQuaternion): Quaternion
        static Phys3D?: typeof phys3D
        static clearPhysicsPool(): void
        /**
         * created by shanexyzhou
         * 生成物理引擎内的RawQuaternion
         */
        toPhysics(): phys3D.RawQuaternion
        setArray(value: ArrayLike<number>, offset?: number): Quaternion
    }
}

declare module 'XrFrame/math/matrix3' {
    import Vector2 from 'XrFrame/math/vector2'
    import V2ReadOnly from 'XrFrame/math/vector2'
    export default class Matrix3 {
        get raw(): Float32Array
        _raw: Float32Array
        /**
         * 使用一个数组创建
         * 此操作会拷贝一份数组
         *
         * @static
         * @param {number[]} array 数据源，长度必须为9，否则会抛出异常
         * @returns {Matrix3} 创建出来的矩阵
         * @memberof Matrix3
         */
        static createFromArray(array: number[]): Matrix3
        /**
         * 使用某个已有的typedArray创建
         * 此操作不会拷贝数据，而是在原来的内存区域上操作
         *
         * @static
         * @param {Float32Array} array 数据源
         * @param {number} [offset=0] 数据源中的偏移
         * @returns {Matrix3} 创建出来的矩阵
         * @memberof Matrix3
         */
        static createFromTypedArray(
            array: Float32Array,
            offset?: number
        ): Matrix3
        /**
         * 返回矩阵数据
         *
         * @returns {number[]} 矩阵数据，以JSArray返回
         * @memberof Matrix3
         */
        toArray(): number[]
        /**
         * 将该矩阵进行位移变换
         *
         * @param {number} tx x轴位移
         * @param {number} ty y轴位移
         * @param {Matrix3} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Matrix3} 计算结果
         * @memberof Matrix3
         */
        translate(tx: number, ty: number, dst?: Matrix3): Matrix3
        /**
         * 将该矩阵进行缩放变换
         *
         * @param {number} sx x轴缩放
         * @param {number} sy y轴缩放
         * @param {Matrix3} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Matrix3} 计算结果
         * @memberof Matrix3
         */
        scale(sx: number, sy: number, dst?: Matrix3): Matrix3
        /**
         * 将该矩阵进行旋转变换
         *
         * @param {number} radians 旋转幅度，用弧度表示
         * @param {Matrix3} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Matrix3} 计算结果
         * @memberof Matrix3
         */
        rotate(radians: number, dst?: Matrix3): Matrix3
        /**
         * 求该矩阵的逆
         *
         * @param {Matrix3} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Matrix3} 计算结果
         * @memberof Matrix3
         */
        inverse(dst?: Matrix3): Matrix3
        /**
         * 将该矩阵与另一个矩阵相乘
         *
         * @param {Matrix3} m 右乘矩阵
         * @param {Matrix3} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Matrix3} 计算结果
         * @memberof Matrix3
         */
        multiply(m: Matrix3, dst?: Matrix3): Matrix3
        /**
         * 矩阵变换作用于点
         *
         * @param {Vector2} v 点
         * @param {Vector2} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Vector2} 计算结果
         * @memberof Matrix3
         */
        transformPoint(v: V2ReadOnly, dst?: Vector2): Vector2
        setArray(value: ArrayLike<number>, offset?: number): Matrix3
    }
}

declare module 'XrFrame/math/matrix4' {
    import Vector3 from 'XrFrame/math/vector3'
    import Vector4 from 'XrFrame/math/vector4'
    import V3ReadOnly from 'XrFrame/math/vector3'
    import V4ReadOnly from 'XrFrame/math/vector4'
    import QuatReadOnly from 'XrFrame/math/quaternion'
    import M3ReadOnly from 'XrFrame/math/matrix3'
    /**
     * @public
     */
    export default class Matrix4 {
        _raw: Float32Array
        /**
         * 构造相机矩阵
         *
         * @static
         * @param {Vector3} position 相机位置
         * @param {Vector3} target 相机目标位置
         * @param {Vector3} up 上方向
         * @param {Matrix4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Matrix4} 计算结果
         * @memberof Matrix4
         */
        static lookAt(
            position: V3ReadOnly,
            target: V3ReadOnly,
            up: V3ReadOnly,
            dst?: Matrix4
        ): Matrix4
        /**
         * 构造透视投影矩阵
         *
         * @static
         * @param {number} fieldOfViewRadians 视野大小，用弧度表示
         * @param {number} aspect 宽高比
         * @param {number} near 近平面
         * @param {number} far 远平面
         * @param {Matrix4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Matrix4} 计算结果
         * @memberof Matrix4
         */
        static perspective(
            fieldOfViewRadians: number,
            aspect: number,
            near: number,
            far: number,
            dst?: Matrix4
        ): Matrix4
        /**
         * 构造正交投影矩阵
         *
         * @static
         * @param {number} left 左平面
         * @param {number} right 右平面
         * @param {number} bottom 上平面
         * @param {number} top 下平面
         * @param {number} near 近平面
         * @param {number} far 远平面
         * @param {Matrix4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Matrix4} 计算结果
         * @memberof Matrix4
         */
        static orthographic(
            left: number,
            right: number,
            bottom: number,
            top: number,
            near: number,
            far: number,
            dst?: Matrix4
        ): Matrix4
        /**
         * 将四元数转换为旋转矩阵
         *
         * @static
         * @param {Quaternion} quat 四元数
         * @param {Matrix4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Matrix4} 计算结果
         * @memberof Matrix4
         */
        static fromQuaternion(quat: QuatReadOnly, dst?: Matrix4): Matrix4
        /**
         * 使用一个数组创建
         * 此操作会拷贝一份数组
         *
         * @static
         * @param {number[]} array 数据源，长度必须为16，否则会抛出异常
         * @returns {Matrix4} 创建出来的矩阵
         * @memberof Matrix4
         */
        static createFromArray(array: number[]): Matrix4
        /**
         * 使用某个已有的typedArray创建
         * 此操作不会拷贝数据，而是在原来的内存区域上操作
         *
         * @static
         * @param {Float32Array} array 数据源
         * @param {number} [offset=0] 数据源中的偏移
         * @returns {Matrix4} 创建出来的矩阵
         * @memberof Matrix4
         */
        static createFromTypedArray(
            array: Float32Array,
            offset?: number
        ): Matrix4
        /**
         * 创建绕X轴旋转的矩阵
         *
         * @static
         * @param {number} rad 旋转幅度，用弧度表示
         * @param {Matrix4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Matrix4} 计算结果
         * @memberof Matrix4
         */
        static createRotationX(rad: number, dst?: Matrix4): Matrix4
        /**
         * 创建绕Y轴旋转的矩阵
         *
         * @static
         * @param {number} rad 旋转幅度，用弧度表示
         * @param {Matrix4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Matrix4} 计算结果
         * @memberof Matrix4
         */
        static createRotationY(rad: number, dst?: Matrix4): Matrix4
        /**
         * 创建绕Z轴旋转的矩阵
         *
         * @static
         * @param {number} rad 旋转轴
         * @param {Matrix4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Matrix4} 计算结果
         * @memberof Matrix4
         */
        static createRotationZ(rad: number, dst?: Matrix4): Matrix4
        /**
         * 创建绕指定轴旋转的矩阵
         *
         * @static
         * @param {Vector3} axis 旋转轴
         * @param {number} angleInRadians 旋转幅度，用弧度表示
         * @param {Matrix4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Matrix4} 计算结果
         * @memberof Matrix4
         */
        static createRotationAxis(
            axis: V3ReadOnly,
            angleInRadians: number,
            dst?: Matrix4
        ): Matrix4
        /**
         * 将位移旋转缩放合成一个RST矩阵，旋转用矩阵表示
         *
         * @static
         * @param {V3ReadOnly} translation 位移向量
         * @param {M4ReadOnly} rotation 旋转矩阵
         * @param {V3ReadOnly} scale 缩放向量
         * @param {Matrix4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Matrix4} 计算结果
         * @memberof Matrix4
         */
        static composeTRS(
            translation: V3ReadOnly,
            rotation: Matrix4,
            scale: V3ReadOnly,
            dst?: Matrix4
        ): Matrix4
        /**
         * 将位移旋转缩放合成一个RST矩阵，旋转用四元数表示
         *
         * @static
         * @param {V3ReadOnly} translation 位移向量
         * @param {QuatReadOnly} rotation 旋转四元数
         * @param {V3ReadOnly} scale 缩放向量
         * @param {Matrix4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Matrix4} 计算结果
         * @memberof Matrix4
         */
        static composeTQS(
            translation: V3ReadOnly,
            rotation: QuatReadOnly,
            scale: V3ReadOnly,
            dst?: Matrix4
        ): Matrix4
        /**
         * 从二维RST矩阵扩展到三维RST矩阵
         *
         * @static
         * @param {Matrix3} m3 二维RST矩阵
         * @param {Matrix4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Matrix4} 计算结果
         * @memberof Matrix4
         */
        static composeFromRST3(m3: M3ReadOnly, dst?: Matrix4): Matrix4
        /**
         * 返回矩阵数据
         *
         * @returns {number[]} 矩阵数据，以JSArray返回
         * @memberof Matrix4
         */
        toArray(): number[]
        /**
         * 将该矩阵进行位移变换
         *
         * @param {number} tx x轴位移
         * @param {number} ty y轴位移
         * @param {number} tz z轴位移
         * @param {Matrix4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Matrix4} 计算结果
         * @memberof Matrix4
         */
        translate(tx: number, ty: number, tz: number, dst?: Matrix4): Matrix4
        /**
         * 将该矩阵进行缩放变换
         *
         * @param {number} sx x轴缩放
         * @param {number} sy y轴缩放
         * @param {number} sz z轴缩放
         * @param {Matrix4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Matrix4} 计算结果
         * @memberof Matrix4
         */
        scale(sx: number, sy: number, sz: number, dst?: Matrix4): Matrix4
        /**
         * 将该矩阵绕x轴旋转
         *
         * @param {number} rx 旋转幅度，用弧度表示
         * @param {Matrix4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Matrix4} 计算结果
         * @memberof Matrix4
         */
        xRotate(rx: number, dst?: Matrix4): Matrix4
        /**
         * 将该矩阵绕y轴旋转
         *
         * @param {number} ry 旋转幅度，用弧度表示
         * @param {Matrix4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Matrix4} 计算结果
         * @memberof Matrix4
         */
        yRotate(ry: number, dst?: Matrix4): Matrix4
        /**
         * 将该矩阵绕z轴旋转
         *
         * @param {number} rz 旋转幅度，用弧度表示
         * @param {Matrix4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Matrix4} 计算结果
         * @memberof Matrix4
         */
        zRotate(rz: number, dst?: Matrix4): Matrix4
        /**
         * 将该矩阵绕指定轴旋转
         *
         * @param {Vector3} axis 轴向量
         * @param {number} angleInRadians 旋转幅度，用弧度表示
         * @param {Matrix4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Matrix4} 计算结果
         * @memberof Matrix4
         */
        axisRotate(
            axis: V3ReadOnly,
            angleInRadians: number,
            dst?: Matrix4
        ): Matrix4
        /**
         * 将该矩阵使用指定四元数旋转
         *
         * @param {Quaternion} quaternion 四元数
         * @param {Matrix4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Matrix4} 计算结果
         * @memberof Matrix4
         */
        rotateByQuaternion(quaternion: QuatReadOnly, dst?: Matrix4): Matrix4
        /**
         * 求该矩阵的逆
         *
         * @param {Matrix4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Matrix4} 计算结果
         * @memberof Matrix4
         */
        inverse(dst?: Matrix4): Matrix4
        /**
         * 求该矩阵的转置
         *
         * @param {Matrix4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Matrix4} 计算结果
         * @memberof Matrix4
         */
        transpose(dst?: Matrix4): Matrix4
        /**
         * 将该矩阵与另一个矩阵相乘
         *
         * @param {Matrix4} m 右乘矩阵
         * @param {Matrix4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Matrix4} 计算结果
         * @memberof Matrix4
         */
        multiply(m: Matrix4, dst?: Matrix4): Matrix4
        /**
         * 矩阵变换作用于向量
         *
         * @param {Vector4} v 向量
         * @param {Vector4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Vector4} 计算结果
         * @memberof Matrix4
         */
        transformVector(v: V4ReadOnly, dst?: Vector4): Vector4
        /**
         * 矩阵变换作用于方向
         *
         * @param {Vector3} dir 方向
         * @param {Vector3} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Vector3} 计算结果
         * @memberof Matrix4
         */
        transformDirection(dir: V3ReadOnly, dst?: Vector3): Vector3
        /**
         * 矩阵变换作用于点
         *
         * @param {Vector3} p 点
         * @param {Vector3} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Vector3} 计算结果
         * @memberof Matrix4
         */
        transformPoint(p: V3ReadOnly, dst?: Vector3): Vector3
        /**
         * 拷贝目标矩阵的值到该矩阵
         *
         * @param {M4ReadOnly} val 目标
         * @returns {Matrix4} 自身
         * @memberof Matrix4
         */
        set(val: Matrix4): Matrix4
        /**
         * 拷贝该矩阵
         *
         * @returns {Matrix4} 拷贝出来的对象
         * @memberof Matrix4
         */
        clone(): Matrix4
        /**
         * 分解RTS矩阵为位移、旋转、缩放向量，返回是否成功
         *
         * @param {Vector3} dstTranslation 目标位移向量
         * @param {Matrix4} dstRotationMatrix 目标旋转矩阵
         * @param {Vector3} dstScale 目标缩放分量
         * @returns {boolean} 分解是否成功，如不成功，可能是缩放分量为0
         * @memberof Matrix4
         */
        decomposeTransRotMatScale(
            dstTranslation: Vector3,
            dstRotationMatrix: Matrix4,
            dstScale: Vector3
        ): boolean
        /**
         * 设置该矩阵某行某列的值
         *
         * @param {number} value 值
         * @param {number} column 列数
         * @param {number} row 行数
         * @returns {Matrix4} 自身
         * @memberof Matrix4
         */
        setValue(value: number, column: number, row: number): Matrix4
        /**
         * 获取矩阵某行某列的值
         *
         *
         * @param {number} column 列数
         * @param {number} row 行数
         * @returns {number} 自身
         * @memberof Matrix4
         */
        getValue(column: number, row: number): number
        /**
         * 设置矩阵某列
         *
         * @param {V4ReadOnly} vec 列向量
         * @param {number} column 列数
         * @returns {Matrix4} 自身
         * @memberof Matrix4
         */
        setColumn(vec: V4ReadOnly, column: number): Matrix4
        /**
         * 获取矩阵某列
         *
         * @param {number} column 列数
         * @param {Vector4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Vector4} 该列数据
         * @memberof Matrix4
         */
        getColumn(column: number, dst?: Vector4): Vector4
        /**
         * 设置矩阵某行
         *
         * @param {V4ReadOnly} vec 行向量
         * @param {number} row 行数
         * @returns {Matrix4} 自身
         * @memberof Matrix4
         */
        setRow(vec: V4ReadOnly, row: number): Matrix4
        /**
         * 获取矩阵某行
         *
         * @param {number} row 行数
         * @param {Vector4} [dst] 计算结果输出到的目标对象，如不传则新建一个
         * @returns {Vector4} 该行数据
         * @memberof Matrix4
         */
        getRow(row: number, dst?: Vector4): Vector4
        setArray(value: ArrayLike<number>, offset?: number): Matrix4
        print(): void
    }
}

declare module 'XrFrame/math/color' {
    import Vector3 from 'XrFrame/math/vector3'
    export enum BlendType {
        Alpha = 0,
        RGB = 1,
        RGBA = 2,
        None = 3
    }
    export const GetColorFromHex: (str: any) => number
    /**
     * @public
     */
    export default class Color {
        get r(): number
        set r(val: number)
        get g(): number
        set g(val: number)
        get b(): number
        set b(val: number)
        get a(): number
        set a(val: number)
        static get WHITE(): Color
        static get BLACK(): Color
        static get TRANSPARENT(): Color
        static BlendType: typeof BlendType
        static blendColorHex(
            colorHexA: number,
            colorHexB: number,
            type?: BlendType
        ): number
        static multiplyColorHex(
            colorHexA: number,
            colorHexB: number,
            type?: BlendType
        ): number
        static getValue32FromRGBA(
            r: number,
            g: number,
            b: number,
            a: number
        ): number
        static getValue32FromHSVA(): void
        static percentRoundFn(num: number): number
        static diffc(v: number, c: number, diff: number): number
        static rgb2hsv(r: number, g: number, b: number, dst?: Vector3): Vector3
        static hsvV2rgb(h: number, s: number, v: number, dst?: Vector3): Vector3
        static randomMix(
            colorHexA: number,
            colorHexB: number,
            randomSeed?: number
        ): number
        static fromHex(hex: number): Color
        static fromHexString(hexString: string): Color
        static fromFloatArray(arr: number[]): Color
        equals(target: Color): boolean
        set(val: Color): void
        setRGBA(r: number, g: number, b: number, a: number): void
        setValue32(v32: number): void
        toNormalizedArray(): [number, number, number, number]
        toRGBAString(): string
        mix(color: Color, dst?: Color): Color
    }
}

declare module 'XrFrame/math/OBB' {
    import Vector3 from 'XrFrame/math/vector3'
    export default class OBB {
        constructor()
        setValues(
            cenX: number,
            cenY: number,
            cenZ: number,
            forward: Vector3,
            w: number,
            h: number,
            d: number
        ): void
        get center(): Vector3
        set center(pos: Vector3)
        get width(): number
        set width(w: number)
        get height(): number
        set height(h: number)
        get depth(): number
        set depth(d: number)
        setForward(forward: Vector3): void
        get AxisX(): Vector3
        get AxisY(): Vector3
        get AxisZ(): Vector3
    }
}

declare module 'XrFrame/math/boundBall' {
    import Vector3 from 'XrFrame/math/vector3'
    import V3ReadOnly from 'XrFrame/math/vector3'
    export default class BoundBall {
        static readonly OFFSETS: Readonly<{
            center: number
            radius: number
        }>
        /**
         * 包围球中心
         *
         * @type {V3ReadOnly}
         * @memberof BoundBall
         */
        get center(): V3ReadOnly
        set center(val: V3ReadOnly)
        /**
         * 包围球半径
         *
         * @type {number}
         * @memberof BoundBall
         */
        get radius(): number
        set radius(val: number)
        _raw: Float32Array
        _offset: number
        protected _center?: Vector3
        constructor(raw?: Float32Array, offset?: number)
        /**
         * 使用中心和半径创建包围球
         *
         * @static
         * @param {V3ReadOnly} center
         * @param {number} radius
         * @returns {BoundBall}
         * @memberof BoundBall
         */
        static createFromCenterAndRadius(
            center: V3ReadOnly,
            radius: number
        ): BoundBall
        /**
         * 设置值
         *
         * @param {V3ReadOnly} center
         * @param {number} radius
         * @returns {BoundBall}
         * @memberof BoundBall
         */
        setValue(center: V3ReadOnly, radius: number): BoundBall
        /**
         * 使用一系列点初始化
         *
         * @param {V3ReadOnly[]} points
         * @returns {BoundBall} 自身
         * @memberof BoundBall
         */
        initByPoints(points: V3ReadOnly[]): BoundBall
        initByPointRadius(center: V3ReadOnly, radius: number): void
    }
}

declare module 'XrFrame/math/boundBox' {
    import Vector3 from 'XrFrame/math/vector3'
    import V3ReadOnly from 'XrFrame/math/vector3'
    export default class BoundBox {
        static readonly OFFSETS: Readonly<{
            center: number
            size: number
        }>
        /**
         * 包围盒中心
         *
         * @type {Vector3}
         * @memberof BoundBox
         */
        get center(): V3ReadOnly
        set center(val: V3ReadOnly)
        /**
         * 包围盒尺寸
         *
         * @memberof BoundBox
         */
        get size(): V3ReadOnly
        set size(val: V3ReadOnly)
        _raw: Float32Array
        _offset: number
        protected _center?: Vector3
        protected _size?: Vector3
        constructor(raw?: Float32Array, offset?: number)
        /**
         * 使用中心和尺寸创建包围球
         *
         * @static
         * @param {V3ReadOnly} center 中心
         * @param {V3ReadOnly} size 尺寸
         * @returns {BoundBall}
         * @memberof BoundBall
         */
        static createFromCenterAndSize(
            center: V3ReadOnly,
            size: V3ReadOnly
        ): BoundBox
        /**
         * 设置值
         *
         * @param {V3ReadOnly} center
         * @param {V3ReadOnly} size
         * @returns {BoundBox}
         * @memberof BoundBox
         */
        setValue(center: V3ReadOnly, size: V3ReadOnly): BoundBox
        initByPoints(points: Vector3[], length?: number): void
        startInitByPoints(): void
        addPoint(corner: Vector3): void
        endInitByPoints(): void
    }
}

declare module 'XrFrame/math/Spherical' {
    /**
     * Spherical.ts
     *
     *         * @Date    : 2022/1/14下午4:49:50
     */
    import Vector3 from 'XrFrame/math/vector3'
    /**
     * 球面坐标系。
     */
    export default class Spherical {
        static EPS: number
        isSpherical: boolean
        /**
         * 球面半径。
         */
        radius: number
        /**
         * 点在球面上的横向旋转角度。
         */
        phi: number
        /**
         * 点在球面上的纵向旋转角度。
         */
        theta: number
        /**
         * 球面球心。
         */
        center: Vector3
        constructor(radius?: number, phi?: number, theta?: number)
        set(radius: number, phi: number, theta: number): this
        clone(): Spherical
        copy(other: Spherical): this
        /**
         * restrict phi to be between EPS and PI-EPS。
         */
        makeSafe(): this
        /**
         * 从笛卡尔坐标系的Vector3转换。
         */
        setFromVector3(vector: Vector3): this
        /**
         * 从笛卡尔坐标系的x、y、z转换。
         */
        setFromCartesianCoords(x: number, y: number, z: number): this
        /**
         * 转换到笛卡尔坐标系的Vector3。
         */
        toVector3(vector?: Vector3): Vector3
    }
}

declare module 'XrFrame/kanata/lib/kanata' {
    import * as IKanata from 'XrFrame/kanata/lib/frontend'
    import { IEngineSettings } from 'XrFrame/kanata/lib/backend/interface'

    export * from 'XrFrame/kanata/lib/backend/interface'
    export {
        ITextureOptions,
        IRenderPassDescriptor
    } from 'XrFrame/kanata/lib/index'

    export type AnimatorComponent = IKanata.AnimatorComponent
    export type CameraComponent = IKanata.CameraComponent
    export type LightCameraComponent = IKanata.LightCameraComponent
    export type CullingComponent = IKanata.CullingComponent
    export type MeshRendererComponent = IKanata.MeshRendererComponent
    export type SkinnedSkeletonComponent = IKanata.SkinnedSkeletonComponent
    export type DynamicBonesComponent = IKanata.DynamicBonesComponent
    export type Entity2D = IKanata.Entity2D
    export type Entity3D = IKanata.Entity3D
    export type AnimationClipModel = IKanata.AnimationClipModel
    export type AnimationClipBinding = IKanata.AnimationClipBinding
    export type AnimatorControllerModel = IKanata.AnimatorControllerModel
    export type AnimatorControllerStateModel =
        IKanata.AnimatorControllerStateModel
    export type DataBuffer = IKanata.DataBuffer
    export type DataModel = IKanata.DataModel
    export type Effect = IKanata.Effect
    export type Material = IKanata.Material
    export type SkeletonBoneInverseModel = IKanata.SkeletonBoneInverseModel
    export type UniformBlock = IKanata.UniformBlock
    export type UniformDescriptor = IKanata.UniformDescriptor
    export type IndexBuffer = IKanata.IndexBuffer
    export type IndexData = IKanata.IndexData
    export type VertexBuffer = IKanata.VertexBuffer
    export type VertexData = IKanata.VertexData
    export type VertexLayout = IKanata.VertexLayout
    export type VertexDataDescriptor = IKanata.VertexDataDescriptor
    export type View = IKanata.View
    export type ScalableList = IKanata.ScalableList
    export type RenderPass = IKanata.RenderPass
    export type Texture = IKanata.Texture
    export type RenderEnv = IKanata.RenderEnv

    export interface IKanataInstance {
        Image: typeof IKanata.Image
        Downloader: typeof IKanata.Downloader
        IS_VALID: typeof IKanata.IS_VALID
        GET_MAIN_CANVAS: typeof IKanata.GET_MAIN_CANVAS
        Phys3D: typeof IKanata.Phys3D
        AnimatorComponent: typeof IKanata.AnimatorComponent
        CameraComponent: typeof IKanata.CameraComponent
        LightCameraComponent: typeof IKanata.LightCameraComponent
        CullingComponent: typeof IKanata.CullingComponent
        MeshRendererComponent: typeof IKanata.MeshRendererComponent
        SkinnedSkeletonComponent: typeof IKanata.SkinnedSkeletonComponent
        DynamicBonesComponent: typeof IKanata.DynamicBonesComponent
        Entity2D: typeof IKanata.Entity2D
        Entity3D: typeof IKanata.Entity3D
        AnimationClipModel: typeof IKanata.AnimationClipModel
        AnimationClipBinding: typeof IKanata.AnimationClipBinding
        AnimatorControllerModel: typeof IKanata.AnimatorControllerModel
        AnimatorControllerStateModel: typeof IKanata.AnimatorControllerStateModel
        DataBuffer: typeof IKanata.DataBuffer
        DataModel: typeof IKanata.DataModel
        Effect: typeof IKanata.Effect
        Material: typeof IKanata.Material
        SkeletonBoneInverseModel: typeof IKanata.SkeletonBoneInverseModel
        UniformBlock: typeof IKanata.UniformBlock
        UniformDescriptor: typeof IKanata.UniformDescriptor
        IndexBuffer: typeof IKanata.IndexBuffer
        IndexData: typeof IKanata.IndexData
        VertexBuffer: typeof IKanata.VertexBuffer
        VertexData: typeof IKanata.VertexData
        VertexLayout: typeof IKanata.VertexLayout
        VertexDataDescriptor: typeof IKanata.VertexDataDescriptor
        View: typeof IKanata.View
        ScalableList: typeof IKanata.ScalableList
        crossContext: typeof IKanata.crossContext
        RenderPass: typeof IKanata.RenderPass
        Texture: typeof IKanata.Texture
        RenderEnv: typeof IKanata.RenderEnv
        renderEnv: typeof IKanata.renderEnv
        createWeakRef: typeof IKanata.createWeakRef
        createWeakRefSentry: typeof IKanata.createWeakRefSentry
        createNativeUUMap: typeof IKanata.createNativeUUMap
        createNativeSUMap: typeof IKanata.createNativeSUMap
        createNativeULUMap: typeof IKanata.createNativeULUMap
        loadTTFFont: typeof IKanata.loadTTFFont
        getGlyphInfo: typeof IKanata.getGlyphInfo
        refreshNodesWorldTransform: typeof IKanata.refreshNodesWorldTransform
        setGlobalPhysicSystem: typeof IKanata.setGlobalPhysicSystem
        bindRigidBodyToNode: typeof IKanata.bindRigidBodyToNode
        bindCCTToNode: typeof IKanata.bindCCTToNode
        unbindRigidBody: typeof IKanata.unbindRigidBody
        unbindCCT: typeof IKanata.unbindCCT
        decodeBase64: typeof IKanata.decodeBase64
        setNodeName: typeof IKanata.setNodeName
        setRenderComponentName: typeof IKanata.setRenderComponentName
        debugPrint: typeof IKanata.debugPrint
        eventBridge: typeof IKanata.eventBridge
        destroy: typeof IKanata.destroy
        update: typeof IKanata.update
    }

    export function CREATE_INSTANCE(
        MAIN_CANVAS: HTMLCanvasElement,
        ENGINE_SETTINGS: IEngineSettings,
        ENGINE_MODE: 'Game' | 'Editor',
        IS_SUB_CONTEXT: boolean,
        HOST: string,
        FIX_INSTANCE: boolean
    ): IKanataInstance
    export function RELEASE_INSTANCE(MAIN_CANVAS: HTMLCanvasElement): void
}

declare module 'XrFrame/core/Scene' {
    /**
     * Scene.ts
     *
     *         * @Date    : 2022/3/16下午3:32:57
     */
    import Transform from 'XrFrame/components/Transform'
    import { Kanata } from 'XrFrame/ext'
    import AssetsSystem from 'XrFrame/systems/AssetsSystem'
    import RenderSystem from 'XrFrame/systems/RenderSystem'
    import Element, { IEntityComponents } from 'XrFrame/core/Element'
    import Material from 'XrFrame/assets/Material'
    import RenderTexture, {
        IRenderTextureOptions
    } from 'XrFrame/assets/RenderTexture'
    import Effect, { IEffectAsset } from 'XrFrame/assets/Effect'
    import Geometry from 'XrFrame/assets/Geometry'
    import AnimationSystem from 'XrFrame/systems/AnimationSystem'
    import PhysicsSystem from 'XrFrame/systems/PhysicsSystem'
    import ARSystem from 'XrFrame/systems/ARSystem'
    import { XRShadow } from 'XrFrame/elements'
    import { GizmoSystem, ShareSystem, VideoSystem } from 'XrFrame/systems'
    import VideoTexture, {
        IVideoTextureOptions
    } from 'XrFrame/assets/VideoTexture'
    import PostProcess, {
        IPostProcessOptions
    } from 'XrFrame/assets/PostProcess'
    /**
     * 场景的默认组件，均为系统。
     */
    export const SceneDefaultComponents: IEntityComponents
    /**
     * 场景的默认映射。
     */
    export const SceneDataMapping: {
        [key: string]: string[]
    }
    export interface TDict<T> {
        [key: string]: T
    }
    /**
     * 场景，系统核心之一。
     *
     * `Scene`是元素的一种，对应于`xr-scene`标签。
     * 作为整个`xr-frame`组件的根节点，它提供了整个组件运作的一些基本能力，挂在了各大系统，驱动生命周期循环。
     */
    export default class Scene extends Element {
        readonly defaultComponents: IEntityComponents
        readonly isScene: boolean
        /**
         * 场景是否已经就绪。
         */
        get ready(): boolean
        /**
         * 自身。
         */
        get scene(): this
        /**
         * 一个可以用于快速挂载自己创建的`Element`的`shadow`节点。
         */
        get rootShadow(): XRShadow
        /**
         * 资源系统。
         */
        get assets(): AssetsSystem
        /**
         * 渲染系统。
         */
        get render(): RenderSystem
        /**
         * 动画系统。
         */
        get animation(): AnimationSystem
        /**
         * 视频系统。
         */
        get video(): VideoSystem
        /**
         * 物理系统。
         */
        get physics(): PhysicsSystem
        /**
         * AR系统。
         */
        get ar(): ARSystem
        /**
         * Gizmo系统。
         */
        get gizmo(): GizmoSystem
        /**
         * 分享系统。
         */
        get share(): ShareSystem
        /**
         * 渲染分辨率宽，一般物理点击事件之类的都是参考这个。
         */
        get width(): number
        /**
         * 渲染分辨率高，一般物理点击事件之类的都是参考这个。
         */
        get height(): number
        /**
         * 显示分辨率宽。
         */
        get frameWidth(): number
        /**
         * 显示分辨率高。
         */
        get frameHeight(): number
        /**
         * 当前时间戳(ms)。
         */
        get timestamp(): number
        /**
         * @internal
         */
        get renderPass(): Kanata.RenderPass
        /**
         * @internal
         */
        get rootNode(): import('XrFrame/kanata/lib/index').Entity3D
        /**
         * @internal
         */
        get backendVersion(): number[]
        /**
         * @internal
         */
        versionBefore(major: number, minor: number): boolean
        /**
         * @internal
         */
        get backendCommit(): string
        /**
         * @internal
         */
        get backendUsePuppetSokol(): boolean
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * 创建一个`Element`，但注意**其只能作为`xr-shadow`的子孙节点**，否则可能会出错！
         *
         * @param attributes 初始化的属性，同于`xml`中对应的标签属性。
         */
        createElement<T extends Element>(
            clz: new (...args: any) => T,
            attributes?: {
                [name: string]: string
            }
        ): T
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * 通过在`wxml`的元素上设置的`id`索引一个元素，`id`是唯一的。
         */
        getElementById(id: string): Element
        /**
         * 通过在`wxml`的元素上设置的`node-id`索引一个`Transform`组件，`node-id`是唯一的。
         */
        getNodeById(nodeId: string): Transform
        /**
         * @internal
         */
        /**
         * 手动创建一个`Image`资源。
         *
         * @param autoRelease 此图片在第一次时候后是否释放原始数据，默认释放。
         */
        createImage(autoRelease?: boolean): Kanata.IImage
        /**
         * 手动创建一个`Texture`资源。
         */
        createTexture(options: Kanata.ITextureOptions): Kanata.Texture
        /**
         * 手动创建一个`Effect`资源。
         */
        createEffect(description: IEffectAsset): Effect
        /**
         * 手动创建一个`UniformBlockDescriptor`资源。
         */
        createUniformBlockDesc(
            options: Kanata.IUniformDescriptorOptions
        ): Kanata.UniformDescriptor
        /**
         * 手动创建一个`UniformBlock`资源。
         */
        createUniformBlock(
            descriptor: Kanata.UniformDescriptor
        ): Kanata.UniformBlock
        /**
         * 手动创建一个`Material`资源。
         */
        createMaterial(
            effect: Effect,
            defaultUniforms?: {
                [key: string]: number | ArrayLike<number> | Kanata.Texture
            }
        ): Material
        /**
         * 手动创建一个`VertexLayout`资源。
         */
        createVertexLayout(
            options: Kanata.IVertexLayoutOptions
        ): Kanata.VertexLayout
        /**
         * 手动创建一个`Geometry`资源。
         */
        createGeometry(
            vertexLayout: Kanata.VertexLayout,
            vBuffer: ArrayBufferView,
            iBuffer: ArrayBufferView,
            indexType?: Kanata.EIndexType
        ): Geometry
        /**
         * 手动创建一个`RenderTexture`资源。
         */
        createRenderTexture(options?: IRenderTextureOptions): RenderTexture
        /**
         * 手动创建一个`VideoTexture`资源。
         */
        createVideoTexture(
            options?: IVideoTextureOptions
        ): Promise<VideoTexture>
        /**
         * 手动创建一个`PostProcess`资源。
         */
        createPostProcess(options: IPostProcessOptions): PostProcess
    }
}

declare module 'XrFrame/core/Observable' {
    export default class Observable<TParams = any, TSender = any> {
        isObservable: boolean
        /**
         * 拥有的监听者数量。
         */
        get count(): number
        /**
         * 添加一个回调到队列中。
         */
        add(
            callback: (params: TParams, sender?: TSender) => void | boolean,
            priority?: number,
            isOnce?: boolean
        ): this
        /**
         * 添加一个回调到队列中，并再被触发执行一次后自动移除。
         */
        addOnce(
            callback: (params: TParams, sender?: TSender) => void | boolean,
            priority?: number
        ): this
        /**
         * 清空队列。
         */
        clear(): this
        /**
         * 从队列中移除一个回调。
         */
        remove(
            callback: (params: TParams, sender?: TSender) => void | boolean
        ): this
        /**
         * 通过一个参数触发一次广播，调用所有回调。
         */
        notify(params: TParams, sender?: TSender): this
    }
}

declare module 'XrFrame/components/Transform' {
    /**
     * Transform.ts
     *
     *         * @Date    : 2022/3/16下午3:48:05
     */
    import Component, { IComponentSchema } from 'XrFrame/core/Component'
    import Element from 'XrFrame/core/Element'
    import Matrix4 from 'XrFrame/math/matrix4'
    import Quaternion from 'XrFrame/math/quaternion'
    import Vector3 from 'XrFrame/math/vector3'
    /**
     * {@link Transform}组件数据接口。
     */
    export interface ITransformData {
        /**
         * 设置一个唯一的节点Id，区别于`xml`上的那个`id`。
         * `xml`中的数据类型为`string`。
         */
        nodeId: string
        /**
         * 节点的位移。
         * `xml`中的数据类型为`number-array`，默认为`0 0 0`。
         */
        position: number[]
        /**
         * 节点的旋转，注意此处为**角度**。
         * `xml`中的数据类型为`number-array`，默认为`0 0 0`。
         */
        rotation: number[]
        /**
         * 节点的位缩放。
         * `xml`中的数据类型为`number-array`，默认为`1 1 1`。
         */
        scale: number[]
        /**
         * 节点的可见性，可以控制该节点以及所有子节点是否可见。
         * `xml`中的数据类型为`boolean`，默认为`true`。
         */
        visible?: boolean
        /**
         * 节点的层级，作为控制节点以及子节点是否可见的一部分，配合{@link Camera.cullMask}使用。
         * 判定规则为自顶层节点向下，只有全部通过了判定才能显示。
         * `xml`中的数据类型为`number`，默认为`0`。
         */
        layer?: number
    }
    /**
     * {@link Transform}的`schema`，详见{@link ITransformData}。
     */
    export const TransformSchema: IComponentSchema
    /**
     * 3D变换组件，作为场景中3D节点的根基，一般被代理到{@link XRNode}元素。
     */
    export default class Transform extends Component<ITransformData> {
        /**
         * 详见{@link TransformSchema}。
         */
        readonly schema: IComponentSchema
        readonly priority: number
        get node(): import('XrFrame/kanata/lib/index').Entity3D
        /**
         * 获取世界矩阵，**注意不可修改**。
         */
        get worldMatrix(): Matrix4
        /**
         * 获取世界绝对位移，**注意不可修改**。
         */
        get worldPosition(): Vector3
        /**
         * 获取世界绝对旋转，**注意不可修改**。
         */
        get worldQuaternion(): Quaternion
        /**
         * 获取世界绝对缩放，**注意不可修改**。
         */
        get worldScale(): Vector3
        /**
         * 获取世界前向向量，**注意不可修改**。
         */
        get worldForward(): Vector3
        /**
         * 获取世界上向向量，**注意不可修改**。
         */
        get worldUp(): Vector3
        /**
         * 获取世界右向向量，**注意不可修改**。
         */
        get worldRight(): Vector3
        get position(): Vector3
        /**
         * 注意如果这里直接修改，使用**弧度**。
         */
        get rotation(): Vector3
        get quaternion(): Quaternion
        get scale(): Vector3
        get visible(): boolean
        set visible(value: boolean)
        get layer(): number
        set layer(value: number)
        /**
         * @internal
         */
        /**
         * 直接设置本地矩阵。
         */
        setLocalMatrix(mat: Matrix4): void
        onAdd(parent: Element, data: ITransformData): void
        onUpdate(data: ITransformData, preData: ITransformData): void
        onTick(deltaTime: number, data: ITransformData): void
        onRemove(parent: Element, data: ITransformData): void
        onRelease(data: ITransformData): void
    }
}

declare module 'XrFrame/components/AssetLoad' {
    /**
     * AssetLoad.ts
     *
     *         * @Date    : 2022/3/31下午4:56:14
     */
    import Component, { IComponentSchema } from 'XrFrame/core/Component'
    import Element from 'XrFrame/core/Element'
    import { IAssetLoadData } from 'XrFrame/loader/types'
    /**
     * {@link AssetLoad}的`schema`，详见{@link IAssetLoadData}。
     */
    export const AssetLoadSchema: IComponentSchema
    /**
     * 用于加载资源的组件，一般被代理到{@link XRAssetLoad}元素。
     */
    export default class AssetLoad extends Component<IAssetLoadData> {
        /**
         * 详见{@link AssetLoadSchema}。
         */
        readonly schema: IComponentSchema
        /**
         * @internal
         */
        get loadParams(): IAssetLoadData<any>
        onAdd(parent: Element, data: IAssetLoadData): void
        onUpdate(data: IAssetLoadData, preData: IAssetLoadData): void
        onRemove(parent: Element, data: IAssetLoadData<any>): void
    }
}

declare module 'XrFrame/components/Assets' {
    /**
     * Assets.ts
     *
     *         * @Date    : 2022/3/24下午3:18:14
     */
    import Component, { IComponentSchema } from 'XrFrame/core/Component'
    import { IAssetLoadData } from 'XrFrame/loader/types'
    export interface IAssetsData {}
    export const AssetsSchema: IComponentSchema
    /**
     * 资源加载组组件，会统计作为其子节点的{@link AssetLoad}组件的加载状态，派发事件。
     * 一般被代理到{@link XRAssets}元素。
     *
     * 事件`progress`会在资源加载进度更新时触发，值为`{progress: number, asset: IAssetLoadData}`。
     * 事件`loaded`会在所有资源加载完成是触发，值为`{assets: {[key: string]: IAssetLoadData}, errors: {[key: string]: Error}}`。
     * 详见{@link IAssetLoadData}。
     */
    export default class Assets extends Component<IAssetsData> {
        readonly schema: IComponentSchema
    }
}

declare module 'XrFrame/components/Camera' {
    /**
     * Camera.ts
     *
     *         * @Date    : 2022/3/17下午5:25:34
     */
    import Component, { IComponentSchema } from 'XrFrame/core/Component'
    import Element from 'XrFrame/core/Element'
    import { Kanata } from 'XrFrame/ext'
    import Vector3 from 'XrFrame/math/vector3'
    import Matrix4 from 'XrFrame/math/matrix4'
    import RenderTexture, { IRenderTarget } from 'XrFrame/assets/RenderTexture'
    import Transform from 'XrFrame/components/Transform'
    import Light from 'XrFrame/components/Light'
    import PostProcess from 'XrFrame/assets/PostProcess'
    /**
     * 相机背景渲染模式。
     *
     * `default`模式只执行默认清屏。
     * `skybox`模式配合{@link Env}组件使用。
     * `ar`模式配合{@link ARSystem}使用。
     */
    export type TCameraBackground = 'default' | 'skybox' | 'ar'
    /**
     * {@link Camera}组件数据接口。
     */
    export interface ICameraData {
        /**
         * 相机对准的目标节点，如果不设置则为自由模式。
         * `xml`中的数据类型为节点对应的`nodeId`。
         */
        target?: Transform
        /**
         * 相机的渲染目标，如果不设置则渲染到屏幕。
         * `xml`中的数据类型为`render-texture`资源。
         */
        renderTarget?: RenderTexture
        /**
         * 深度，决定在多相机时的渲染顺序。
         * `xml`中的数据类型为`number`。
         */
        depth: number
        /**
         * 掩码，一般和{@link Transform.layer}一起使用，决定那些节点要被渲染。
         * `xml`中的数据类型为`number`。
         */
        cullMask: number
        /**
         * 是否为透视相机。
         * `xml`中的数据类型为`boolean`，默认为`true`。
         */
        isPerspective: boolean
        /**
         * 视场角。
         * `xml`中的数据类型为`number`，默认为`60`。
         */
        fov: number
        /**
         * 近平面。
         * `xml`中的数据类型为`number`，默认为`0.1`。
         */
        near: number
        /**
         * 远平面。
         * `xml`中的数据类型为`number`，默认为`100`。
         */
        far: number
        /**
         * 非透视模式，即正交模式时，可视范围大小。
         * `xml`中的数据类型为`number`，默认为`4`。
         */
        orthSize: number
        /**
         * 背景清屏模式。
         * `xml`中的数据类型为`string`，默认为`default`。
         */
        background: TCameraBackground
        /**
         * 是否为AR相机，配合{@link ARSystem}使用。
         * `xml`中的数据类型为`boolean`，默认为`false`。
         * **非常需要注意当设置为`true`时不能同时设置`target`数据！**
         */
        isARCamera: boolean
        /**
         * 清屏是否要清深度。
         * `xml`中的数据类型为`boolean`，默认为`true`。
         */
        isClearDepth: boolean
        /**
         * 清屏是否要清模板值。
         * `xml`中的数据类型为`boolean`，默认为`true`。
         */
        isClearStencil: boolean
        /**
         * 清屏是否要清颜色。
         * `xml`中的数据类型为`boolean`，默认为`true`。
         */
        isClearColor: boolean
        /**
         * 清屏深度。
         * `xml`中的数据类型为`number`，默认为`1`。
         */
        clearDepth: number
        /**
         * 清屏模板值。
         * `xml`中的数据类型为`number`，默认为`0`。
         */
        clearStencil: number
        /**
         * 清屏颜色。
         * `xml`中的数据类型为`color`，默认为`0 0 0 1`。
         */
        clearColor: number[]
        /**
         * 后处理，一个后处理资源id的数组。
         * `xml`中的数据类型为`array`，默认为空。
         */
        postProcess: string[]
    }
    /**
     * {@link Camera}的`schema`，详见{@link ICameraData}。
     */
    export const CameraSchema: IComponentSchema
    /**
     * 相机组件，一般被代理到{@link XRCamera}元素。
     */
    export default class Camera extends Component<ICameraData> {
        /**
         * 详见{@link CameraSchema}。
         */
        readonly schema: IComponentSchema
        readonly priority: number
        /**
         * 相机深度。
         */
        get depth(): number
        /**
         * @internal
         */
        get renderTarget(): IRenderTarget
        /**
         * @internal
         */
        get view(): import('XrFrame/kanata/lib/index').View
        /**
         * @internal
         */
        get id(): number
        /**
         * @internal。
         */
        get bgStates(): {
            [key: string]: any
        }
        /**
         * @internal。
         */
        get bgStatesClear(): boolean
        get background(): TCameraBackground
        get target(): Transform
        get near(): number
        get far(): number
        get cullMask(): number
        get postProcess(): PostProcess[]
        get hdr(): boolean
        /**
         * @internal
         */
        cull(cullResult: Kanata.ScalableList, lightMode: string): void
        /**
         * @internal
         */
        clear(): void
        /**
         * @internal
         */
        draw(renderList: Kanata.ScalableList, lightMode: string): void
        /**
         * @internal
         */
        drawLight(
            light: Light,
            renderList: Kanata.ScalableList,
            lightMode: string
        ): void
        /**
         * 将世界坐标系位置转换到齐次裁剪空间。
         */
        convertWorldPositionToClip(worldPos: Vector3, dst?: Vector3): Vector3
        /**
         * 将齐次裁剪空间转换到世界坐标系位置。
         */
        convertClipPositionToWorld(clipPos: Vector3, dst?: Vector3): Vector3
        /**
         * 修改viewMatrix的设置类型。
         *
         * @param manual 是否要设置为手动模式。
         * @param mat4 手动模式下，要设置的值。
         */
        changeViewMatrix(manual: boolean, mat4?: Matrix4 | Float32Array): void
        /**
         * 修改projectMatrix的设置类型。
         *
         * @param manual 是否要设置为手动模式。
         * @param mat4 手动模式下，要设置的值。
         */
        changeProjectMatrix(
            manual: boolean,
            mat4?: Matrix4 | Float32Array
        ): void
        /**
         * 修改相机背景的渲染状态。
         *
         * @param states 同{@link Material.setRenderStates}
         */
        setBackgroundRenderStates(states: { [key: string]: any }): void
        clearBackgroundRenderStates(): void
        onAdd(parent: Element, data: ICameraData): void
        onUpdate(data: ICameraData, preData: ICameraData): void
        onRemove(parent: Element, data: ICameraData): void
        onRelease(data: ICameraData): void
        protected _processData(data: ICameraData, preData: ICameraData): void
    }
}

declare module 'XrFrame/components/GLTF' {
    import GLTFModel from 'XrFrame/assets/GLTFModel'
    import Component, { IComponentSchema } from 'XrFrame/core/Component'
    import Element from 'XrFrame/core/Element'
    import BoundBox from 'XrFrame/math/boundBox'
    import Mesh from 'XrFrame/components/Mesh'
    /**
     * @see {@link GLTF}
     */
    export interface IGLTFData {
        /**
         * 已加载完毕的GLTF模型。
         */
        model: GLTFModel
        /**
         * 是否投射阴影，默认false。
         */
        castShadow?: boolean
        /**
         * 是否接受阴影，默认false。
         */
        receiveShadow?: boolean
        /**
         * 是否不参与剔除，默认false(即参与剔除)。
         */
        neverCull?: boolean
        /**
         * 修改GLTF的默认renderStates。
         */
        states?: Array<[string, string]>
    }
    export const GLTFSchema: IComponentSchema
    interface ElementGLTFInfo {
        el: Element
        hasMesh: boolean
        meshName?: string
        meshes?: Mesh[]
    }
    /**
     * 将一个{@link GLTFModel | GLTF模型}实例化并渲染出来。
     * {@link XRGLTF | xr-gltf}标签会自动生成该组件。
     *
     * > 会在当前元素下新建一系列子元素，作为GLTF模型的每个场景的根节点。
     * > 会在当前元素上新建{@link Animator}组件，并向其添加实例化生成的动画片段。
     *
     * @see {@link IGLTFData}
     */
    export default class GLTFComponent extends Component<IGLTFData> {
        readonly schema: IComponentSchema
        readonly priority: number
        _subRoots: Element[]
        onUpdate(data: IGLTFData, preData: IGLTFData): void
        onRemove(parent: Element, data: IGLTFData): void
        onRelease(data: IGLTFData): void
        /**
         * 根据GLTF模型中节点的`name`字段来获取内部元素。
         */
        getInternalNodeByName(name: string): Element | undefined
        /**
         * @internal
         */
        /**
         * 获取GLTF模型实例化过程中生成的所有{@link Mesh}组件。
         */
        get meshes(): Mesh[]
        /**
         * 计算GLTF模型整体的包围盒，返回**模型空间**内的计算结果。
         * 每次调用都会重新计算。
         */
        calcTotalBoundBox(): BoundBox
        /**
         * 根据GLTF模型中**引用**了Mesh的**Node节点**的`name`字段，来获取对应Mesh下的所有Primitive。
         * 一个GLTF模型中的Primitive节点对应返回中的一个`xr-frame Mesh组件`实例。
         * **如果没有该名字的节点，或者节点未引用Mesh，会返回空数组。*
         * @param name Node节点的`name`（而非Mesh节点）
         */
        getPrimitivesByNodeName(name: string): Mesh[]
        /**
         * 根据GLTF模型中Mesh节点的`name`字段，来获取引用了该Mesh的**所有**Node节点下的所有Primitive。
         * 在xr-frame实现中，每个引用了该Mesh的GLTFNode节点拥有**独立**的一份Primitives副本，**每个**Node节点下的**每个**Primitive对应一个`xr-frame Mesh组件`。
         * **如果没有引用了该Mesh的Node节点，会返回空数组。*
         * @param name Mesh节点的`name`
         * @returns 一个数组，数组中的一个元素对应一个引用了该Mesh的GLTFNode节点，元素中nodeName为GLTFNode节点的`name`字段。
         */
        getPrimitivesByMeshName(name: string): Array<{
            nodeName: string
            primitives: Mesh[]
        }>
    }
    export {}
}

declare module 'XrFrame/components/Light' {
    /**
     * Light.ts
     *
     *         * @Date    : 2022/3/16下午4:45:56
     */
    import Component, { IComponentSchema } from 'XrFrame/core/Component'
    import Element from 'XrFrame/core/Element'
    import { Kanata } from 'XrFrame/ext'
    /**
     * 光照类型枚举。
     */
    export enum ELightType {
        /**
         * 环境光，默认只有一个生效。
         */
        Ambient = 'ambient',
        /**
         * 平行光，默认第一个会成为主平行光。
         */
        Directional = 'directional',
        /**
         * 点光。
         */
        Point = 'point',
        /**
         * 聚光。
         */
        Spot = 'spot'
    }
    /**
     * {@link Light}组件数据接口。
     */
    export interface ILightData {
        /**
         * 类型。
         * `xml`中的数据类型`string`，默认为`directional`。
         */
        type: ELightType
        /**
         * 颜色。
         * `xml`中的数据类型`color`，默认为`[1, 1, 1, 1]`。
         */
        color: number[]
        /**
         * 强度。
         * `xml`中的数据类型`number`，默认为`1`。
         */
        intensity: number
        /**
         * 范围，仅在电光和聚光有效。
         * `xml`中的数据类型`number`，默认为`1`。
         */
        range: number
        /**
         * 仅在聚光有效。
         * `xml`中的数据类型`number`，默认为`1`。
         */
        innerConeAngle: number
        /**
         * 仅在聚光有效。
         * `xml`中的数据类型`number`，默认为`1`。
         */
        outerConeAngle: number
        /**
         * 是否要产生阴影，仅对平行光有效。
         * `xml`中的数据类型`boolean`，默认为`false`。
         */
        castShadow?: boolean
        /**
         * 产生阴影的最大距离，仅对平行光有效。
         * `xml`中的数据类型`number`，默认为`10`。
         */
        shadowDistance?: number
        /**
         * 阴影采样时的容许偏移，仅对平行光有效。
         * `xml`中的数据类型`number`，默认为`0.002`。
         */
        shadowBias?: number
    }
    /**
     * {@link Light}的`schema`，详见{@link ILightData}。
     */
    export const LightSchema: IComponentSchema
    /**
     * 灯光组件，一般被代理到{@link XRLight}元素。
     *
     * 注意整个场景只能存在一个`ambient`光源，第一个`directional`光源将会成为主光源，也只有这个光源能够产生阴影。
     * 目前最多支持四个追加光源。
     */
    export default class Light extends Component<ILightData> {
        /**
         * 详见{@link LightSchema}。
         */
        readonly schema: IComponentSchema
        readonly priority: number
        get type(): ELightType
        get color(): number[]
        get intensity(): number
        get range(): number
        get innerConeAngle(): number
        get outerConeAngle(): number
        get castShadow(): boolean
        get shadowDistance(): number
        get shadowBias(): number
        /**
         * @internal
         */
        get lightCamera(): import('XrFrame/kanata/lib/index').LightCameraComponent
        /**
         * @internal
         */
        onAdd(parent: Element, data: ILightData): void
        onUpdate(data: ILightData, preData: ILightData): void
        onTick(deltaTime: number, data: ILightData): void
        onRemove(parent: Element, data: ILightData): void
        onRelease(data: ILightData): void
        /**
         * @internal
         */
    }
}

declare module 'XrFrame/components/AssetMaterial' {
    import Effect from 'XrFrame/assets/Effect'
    import Component, { IComponentSchema } from 'XrFrame/core/Component'
    import Element from 'XrFrame/core/Element'
    /**
     * `AssetMaterial`数据接口。
     */
    export interface IAssetMaterialData {
        /**
         * 被引用时的资源Id。
         * `xml`中的数据类型为`string`。
         */
        assetId: string
        /**
         * 基于的效果。
         * `xml`中的数据类型为`effect`资源，默认为`simple`。
         */
        effect: Effect
        /**
         * 初始要写入的`uniforms`，类型根据`effect`中的定义决定。
         * `xml`中的数据类型为`map`。
         */
        uniforms: Array<[string, string]>
        /**
         * 初始要写入的渲染状态`states`。
         * `xml`中的数据类型为`map`。
         * 目前支持`renderQueue`、`cullOn`、`depthTestOn`、`depthTestWrite`、`alphaMode`、`alphaCutOff`。
         * `alphaMode`和`alphaCutOff`遵循glTF标准。
         */
        states: Array<[string, string]>
        /**
         * 要覆盖的渲染顺序。
         * `xml`中的数据类型为`number`，无默认值。
         * 大于等于`2500`视为透明物体。
         */
        renderQueue: number
    }
    /**
     * {@link AssetMaterial}的`schema`，详见{@link IAssetMaterialData}。
     */
    export const AssetMaterialSchema: IComponentSchema
    /**
     * 材质资源创建组件，为了在`xml`中创建{@link Material}资源，一般被代理到{@link XRAssetMaterial}元素。
     */
    export default class AssetMaterial extends Component<IAssetMaterialData> {
        /**
         * 详见{@link AssetMaterialSchema}。
         */
        readonly schema: IComponentSchema
        onAdd(parent: Element, data: IAssetMaterialData): void
        onUpdate(data: IAssetMaterialData, preData: IAssetMaterialData): void
        onRemove(parent: Element, data: IAssetMaterialData): void
    }
}

declare module 'XrFrame/components/Mesh' {
    /**
     * Model.ts
     *
     *         * @Date    : 2022/3/16下午4:48:09
     */
    import Geometry from 'XrFrame/assets/Geometry'
    import Component, { IComponentSchema } from 'XrFrame/core/Component'
    import Element from 'XrFrame/core/Element'
    import { Kanata } from 'XrFrame/ext'
    import Material from 'XrFrame/assets/Material'
    import Transform from 'XrFrame/components/Transform'
    /**
     * `Mesh`数据接口。
     */
    export interface IMeshData {
        /**
         * 是否强制不被剔除。
         * `xml`中的数据类型为`boolean`，默认为`false`。
         */
        neverCull?: boolean
        /**
         * 在主光源产生阴影开启阴影时，是否要产生阴影。
         * `xml`中的数据类型为`boolean`，默认为`false`。
         */
        castShadow?: boolean
        /**
         * 在主光源产生阴影开启阴影时，是否要接受阴影。
         * `xml`中的数据类型为`boolean`，默认为`false`。
         */
        receiveShadow?: boolean
        /**
         * 渲染使用的几何数据。
         * `xml`中的数据类型为`geometry`资源。
         */
        geometry: Geometry
        /**
         * 渲染使用的材质数据。
         * `xml`中的数据类型为`material`资源。
         */
        material?: Material
        /**
         * 覆盖`material`中的默认`uniforms`，如果覆盖了，则会先创建一个材质副本。
         * `xml`中同{@link IMaterialData.uniforms}。
         */
        uniforms?: Array<[string, string]>
        /**
         * 覆盖`material`中的默认`states`，如果覆盖了，则会先创建一个材质副本。
         * `xml`中同{@link IMaterialData.states}。
         */
        states?: Array<[string, string]>
    }
    /**
     * {@link Mesh}的`schema`，详见{@link IMeshData}。
     */
    export const MeshSchema: IComponentSchema
    /**
     * Mesh组件，整合{@link Geometry}和{@link Material}进行渲染，一般被代理到{@link XRMesh}元素。
     */
    export default class Mesh extends Component<IMeshData> {
        /**
         * 详见{@link MeshSchema}。
         */
        readonly schema: IComponentSchema
        readonly priority: number
        protected _cull: Kanata.CullingComponent
        protected _mesh: Kanata.MeshRendererComponent
        protected _sourceMaterial: Material
        protected _geometry: Geometry
        protected _material: Material
        protected _trs: Transform
        /**
         * 几何数据。
         */
        get geometry(): Geometry
        /**
         * 材质。
         */
        get material(): Material
        set material(value: Material)
        /**
         * MorphTargets的权重，最多32个，可以获取后直接修改。
         */
        get morphWeights(): Float32Array
        /**
         * @internal
         */
        get id(): number
        /**
         * @internal
         */
        onAdd(parent: Element, data: IMeshData): void
        onTick(deltaTime: number, data: IMeshData): void
        onUpdate(data: IMeshData, preData: IMeshData): void
        onRemove(parent: Element, data: IMeshData): void
        onRelease(data: IMeshData): void
        /**
         * @internal
         */
        protected _getMarcos(geometry: Geometry): {}
        /**
         * @internal
         */
        protected _getUniformDesc(): Kanata.UniformDescriptor
        /**
         * @internal
         */
        protected _getMeshType(): Kanata.EMeshRenderType
    }
}

declare module 'XrFrame/components/Text' {
    import Component, { IComponentSchema } from 'XrFrame/core/Component'
    import Element from 'XrFrame/core/Element'
    import { Kanata } from 'XrFrame/ext'
    import Material from 'XrFrame/assets/Material'
    import Transform from 'XrFrame/components/Transform'
    import { IGlyph } from 'XrFrame/glyph'
    export interface ITextData {
        neverCull?: boolean
        material?: Material
        uniforms?: Array<[string, string]>
        states?: Array<[string, string]>
        value?: string
    }
    export interface ICharacterData {
        x: number
        y: number
        width: number
        height: number
        batchIndex: number
        character: string
        glyph: IGlyph
    }
    export interface IRenderData {
        vertexBuffer?: Kanata.VertexBuffer
        indexBuffer?: Kanata.IndexBuffer
        vertexNum?: number
        indiceNum?: number
        texture?: number
    }
    export const TextSchema: IComponentSchema
    export default class Text extends Component<ITextData> {
        readonly schema: IComponentSchema
        readonly priority: number
        protected _cull: Kanata.CullingComponent
        protected _mesh: Kanata.MeshRendererComponent
        protected _sourceMaterial: Material
        protected _material: Material
        protected _trs: Transform
        protected _value: string
        protected _glyphs: IGlyph[]
        protected _renderDatas: IRenderData[]
        get value(): string
        get material(): Material
        set material(value: Material)
        get id(): number
        onAdd(parent: Element, data: ITextData): void
        onTick(deltaTime: number, data: ITextData): void
        onUpdate(data: ITextData, preData: ITextData): void
        onRemove(parent: Element, data: ITextData): void
        onRelease(data: ITextData): void
        protected _getUniformDesc(): Kanata.UniformDescriptor
        protected _getMeshType(): Kanata.EMeshRenderType
        protected _getVertexLayout(): Kanata.VertexLayout
    }
}

declare module 'XrFrame/components/particle/Particle' {
    import Element from 'XrFrame/core/Element'
    import Material from 'XrFrame/assets/Material'
    import BasicParticle, {
        IParticleData
    } from 'XrFrame/components/particle/BasicParticle'
    import ParticleInstance from 'XrFrame/components/particle/ParticleInstance'
    import { BasicShapeEmitter } from 'XrFrame/components/emitter/BasicShapeEmitter'
    export default class Particle extends BasicParticle {
        readonly priority: number
        subEmitters: any
        get material(): Material
        set material(value: Material)
        get id(): number
        get data(): IParticleData
        set data(value: IParticleData)
        get particleEmitter(): BasicShapeEmitter
        /**
         * 粒子系统开始播放。
         *
         * @param delay 设定粒子延时几秒后再播放。
         */
        start(delay: any): void
        /**
         * 停止粒子系统与其子发射器的播放。
         */
        stop(): void
        /**
         * @internal
         */
        onAdd(parent: Element, data: IParticleData): void
        /**
         * 设置粒子系统的内置粒子effect。
         */
        protected createMaterial(): Material
        /**
         * 初始化粒子系统的状态。
         */
        initParticle(data: IParticleData): void
        /**
         * 重置粒子系统的状态。
         */
        resetParticle(): void
        /**
         * @internal
         */
        protected _prepareSubEmitterArray(): void
        /**
         * 停止所有粒子子系统的发射状态。
         */
        protected stopSubEmitters(): void
        /**
         * 粒子子发射系统从依附的粒子系统中剥离。
         */
        protected removeFromRoot(): void
        /**
         * @internal
         */
        onTick(deltaTime: number, data: IParticleData): void
        /**
         * @internal
         */
        onUpdate(data: IParticleData, preData: IParticleData): void
        /**
         * @internal
         */
        onRemove(parent: Element, data: IParticleData): void
        /**
         * @internal
         */
        onRelease(data: IParticleData): void
        /**
         * @internal
         */
        protected _updateRenderData(
            deltaTime: number,
            isPreWarm?: boolean
        ): void
        /**
         * 创建一个粒子实例。
         */
        protected createParticle(): ParticleInstance
        /**
         * 启动处于END状态的粒子子发射器。
         * @param {ParticleInstance} instance 粒子实例
         */
        protected particleSubEmitter(instance: ParticleInstance): void
        /**
         * 回收当前粒子实例，并放入储备粒子队列。
         * @param {ParticleInstance} particle 粒子实例
         */
        protected recycleParticle(particle: ParticleInstance): void
        /**
         * 更新每一个粒子的状态。
         * @param {number} instancesSum 新生成的粒子数
         */
        protected update(instancesSum: number): void
        /**
         * 初始化粒子实例。
         * @param {ParticleInstance} instance 需要初始化的粒子实例
         */
        protected initInstanceProperty(instance: ParticleInstance): void
        /**
         * 更新运动过程中粒子实例的各项属性以及子发射器状态。
         * @param {Array} instances 粒子实例数组
         */
        protected updateInstanceProperty(instances: any): void
        /**
         * 更新粒子实例的各项属性。
         * @param {ParticleInstance} instance 待更新的粒子实例
         */
        protected processInstance(instance: ParticleInstance): void
    }
}

declare module 'XrFrame/components/particle/BasicParticle' {
    import Material from 'XrFrame/assets/Material'
    import Component from 'XrFrame/core/Component'
    import { IComponentSchema } from 'XrFrame/core/Component'
    import {
        BoxShapeEmitter,
        PointShapeEmitter,
        SphereShapeEmitter
    } from 'XrFrame/components/emitter'
    import { Kanata } from 'XrFrame/ext'
    import Transform from 'XrFrame/components/Transform'
    import { BasicShapeEmitter } from 'XrFrame/components/emitter/BasicShapeEmitter'
    import Vector3 from 'XrFrame/math/vector3'
    import Particle from 'XrFrame/components/particle/Particle'
    import { Scene } from 'XrFrame/elements'
    import { SubEmitter } from 'XrFrame/components/emitter/SubEmitter'
    import ParticleInstance from 'XrFrame/components/particle/ParticleInstance'
    import Atlas from 'XrFrame/assets/Atlas'
    import Vector4 from 'XrFrame/math/vector4'
    import Geometry from 'XrFrame/assets/Geometry'
    /**
     * {@link Particle}组件数据接口。
     */
    export interface IParticleData {
        neverCull?: boolean
        /**
         * 渲染模式。
         */
        renderMode?: string
        uniforms?: Array<[string, string]>
        states?: Array<[string, string]>
        /**
         * 纹理信息。
         */
        texture?: Kanata.Texture
        /**
         * 最大粒子数目。
         */
        capacity?: number
        /**
         * 每秒粒子发射数。
         */
        emitRate?: number
        /**
         * 初始角度。
         */
        angle?: number[]
        /**
         * 粒子系统启动延时秒数。
         */
        delay?: number
        /**
         * y轴方向上的每秒位移。
         */
        gravity?: number
        /**
         * 初始大小。
         */
        size?: number[]
        /**
         * 粒子在x轴方向上的大小尺度。
         */
        scaleX?: number[]
        /**
         * 粒子在y轴方向上的大小尺度。
         */
        scaleY?: number[]
        /**
         * 速度。
         */
        speed?: number[]
        /**
         * 生命周期时长。
         */
        lifeTime?: number[]
        /**
         * 粒子初始颜色左区间。
         */
        startColor?: number[]
        /**
         * 粒子初始颜色右区间。
         */
        startColor2?: number[]
        /**
         * 粒子结束时颜色。
         */
        endColor?: number[]
        /**
         * 角速度。
         */
        angularSpeed?: number[]
        /**
         * 发射器类型。
         */
        emitterType?: string
        /**
         * 发射器属性配置。
         */
        emitterProps?: Array<[string, string]>
        /**
         * 粒子系统生命周期时长。
         */
        stopDuration?: number
        /**
         * 粒子预渲染周期数。
         */
        prewarmCycles?: number
        /**
         * 速度阻尼系数。
         */
        speedDampen?: number
        /**
         * 动画图集信息。
         */
        atlas?: Atlas
        /**
         * 图集切换速度。
         */
        atlasSpeed?: number
        /**
         * 是否随机播放图集。
         */
        atlasRandom?: boolean
        /**
         * 是否循环播放图集。
         */
        atlasLoop?: boolean
        /**
         * 指定图集帧名。
         */
        atlasFrames?: string[]
        /**
         * 网格信息。
         */
        mesh?: Geometry
        sizeChange?: Array<[string, string]>
        colorChange?: Array<[string, string]>
        speedChange?: Array<[string, string]>
        burstCount?: number
        burstTime?: number
        burstCycle?: number
        burstInterval?: number
    }
    /**
     * {@link Particle}的`schema`定义。
     * @see 解析后的接口详见 {@link IParticleData}
     */
    export const ParticleSchema: IComponentSchema
    /**
     * BillBoard渲染模式。
     */
    export const enum BillBoardMode {
        BILLBOARDMODE_DEFAULT = 0,
        BILLBOARDMODE_Y = 1,
        BILLBOARDMODE_STRETCHED = 2
    }
    export default class BasicParticle extends Component<IParticleData> {
        /**
         * 详见{@link ParticleSchema}。
         */
        readonly schema: IComponentSchema
        protected static count: number
        protected _systemId: number
        protected _data: IParticleData
        protected particleScene: Scene
        protected particleEl: any
        protected _instances: ParticleInstance[]
        protected _stockInstances: ParticleInstance[]
        protected _capacity: number
        protected _delay: number
        protected _updateSpeed: number
        protected _stopDuration: number
        protected _emitRate: number
        protected _gravity: number
        protected _preWarmCycles: number
        protected _preWarmStepOffset: number
        protected _particleEmitterType: string
        protected _particleEmitter: BasicShapeEmitter
        protected _particleEmitterProperties: any
        protected particleStride: number
        protected particleVertexSize: number
        protected byteStride: number
        protected ParticleAttributes: any
        protected _burstCount: number
        protected _burstTime: number
        protected _burstCycle: number
        protected _burstInterval: number
        protected _burstCountTime: number
        protected _burstCountCycle: number
        protected _burstCountInterval: number
        protected _minLifeTime: number
        protected _maxLifeTime: number
        protected _minScaleX: number
        protected _maxScaleX: number
        protected _minScaleY: number
        protected _maxScaleY: number
        protected _minSize: number
        protected _maxSize: number
        protected _minSpeed: number
        protected _maxSpeed: number
        protected _particleLengthScale: number
        protected _startColor: number[]
        protected _startColor2: number[]
        protected _endColor: number[]
        protected _sizeGradients: any
        protected _alphaGradients: any
        protected _colorRemapGradients: any
        protected _speedScaleGradients: any
        protected _limitSpeedGradients: any
        protected _speedDampenFactor: number
        protected _dragGradients: any
        protected _useSpriteSheet: boolean
        protected _startSpriteCellIndex: number
        protected _endSpriteCellIndex: number
        protected _useRandomSpriteCellIndex: boolean
        protected _useSpriteCellLoop: boolean
        protected _spriteChangeSpeed: number
        protected _spriteFrameInfo: Vector4[]
        protected _spriteNameToCellIndex: Map<string, number>
        protected _textureData: Kanata.Texture
        protected _atlasObj: Atlas
        protected _atlasTexture: Kanata.Texture
        protected _cull: Kanata.CullingComponent
        protected _mesh: Kanata.MeshRendererComponent
        protected _sourceMaterial: Material
        protected _material: Material
        protected _trs: Transform
        protected _vertexBuffer: Kanata.VertexBuffer
        protected _indexBuffer: Kanata.IndexBuffer
        protected _renderMesh: Geometry
        protected _vertexCount: number
        protected _vertexData: Float32Array
        protected _eachIndexSize: number
        protected _indexSize: number
        protected _vertexSize: number
        protected _useBillboard: boolean
        protected _useRenderMesh: boolean
        protected _billboardMode: number
        protected _useRampGradients: boolean
        protected _rampGradients: any
        protected _rampGradientsTexture: Kanata.Texture
        protected _colorGradients: any
        protected _vertexLayoutDirty: boolean
        protected _startAngle: number
        protected _startAngle2: number
        protected _minAngularSpeed: number
        protected _maxAngularSpeed: number
        protected _subEmitters: any[]
        protected _emitterPosition: Vector3
        get material(): Material
        /**
         * @internal
         */
        get useBillboard(): boolean
        set useBillboard(value: boolean)
        get useRampGradients(): boolean
        set useRampGradients(value: boolean)
        get billboardMode(): number
        set billboardMode(value: number)
        get useSpriteSheet(): boolean
        set useSpriteSheet(value: boolean)
        get useRandomSpriteCellIndex(): boolean
        get useSpriteCellLoop(): boolean
        get spriteChangeSpeed(): number
        get emitterPosition(): Vector3
        set emitterPosition(value: Vector3)
        /**
         * @internal
         */
        protected _parseAttribute(): void
        /**
         * 获取一个拷贝的粒子系统。
         */
        clone(): Particle
        /**
         * 获取一个粒子子发射器。
         */
        createSubEmitter(data: IParticleData): SubEmitter
        /**
         * 创建一个点发射器。
         * @param {Vector3} direction1 粒子运动方向左区间
         * @param {Vector3} direction2 粒子运动方向右区间
         * @return {PointShapeEmitter} 点发射器
         */
        createPointEmitter(
            direction1: Vector3,
            direction2: Vector3
        ): PointShapeEmitter
        /**
         * 创建一个箱形发射器。
         * @param {Vector3} direction1 粒子运动方向左区间
         * @param {Vector3} direction2 粒子运动方向右区间
         * @param {Vector3} minEmitBox 粒子生成位置最小允许坐标
         * @param {Vector3} maxEmitBox 粒子生成位置最大允许坐标
         * @return {BoxShapeEmitter} 箱形发射器
         */
        createBoxEmitter(
            direction1: Vector3,
            direction2: Vector3,
            minEmitBox: Vector3,
            maxEmitBox: Vector3
        ): BoxShapeEmitter
        /**
         * 创建一个球形发射器。
         * @param {number} radius 球形半径
         * @param {number} radiusRange 球形区域内的覆盖范围[0-1]
         * @param {number} arc 粒子在球形内生成的角度区间[0-360]
         * @param {number} randomizeDirection 粒子运动方向偏离程度[0-1]
         * @return {SphereShapeEmitter} 球形发射器
         */
        createSphereEmitter(
            radius: number,
            radiusRange: number,
            arc: number,
            randomizeDirection: number
        ): SphereShapeEmitter
        protected _parseProperties(data: IParticleData): void
        protected _chooseEmitterProcess(): void
        protected _createVertexBuffers(): void
        protected _createIndexBuffer(): void
        protected _appendParticleVertices(
            offset: any,
            instance?: ParticleInstance
        ): void
        protected _appendParticleVertex(
            index: any,
            instance: ParticleInstance,
            offsetX: any,
            offsetY: any,
            offsetZ: any,
            u: any,
            v: any
        ): void
        protected _rebuildMesh(neverCull: boolean): void
        protected _getUniformDesc(): Kanata.UniformDescriptor
        protected _getMeshType(): Kanata.EMeshRenderType
        protected _getVertexLayout(
            attributes: any,
            stride: any
        ): Kanata.VertexLayout
        protected _setMeshData(
            material: Material,
            uniforms?: Array<[string, string]>,
            states?: Array<[string, string]>
        ): void
        /**
         * 添加粒子运动过程中的颜色变化规则。
         * @param {number} gradient 指定所处粒子生命周期的阶段
         * @param {Vector4} color1 指定粒子颜色的左区间
         * @param {Vector4} color2 指定粒子颜色的右区间
         */
        addColorGradient(
            gradient: number,
            color1: Vector4,
            color2?: Vector4
        ): void
        /**
         * 添加粒子运动过程中的速度变化规则。
         * @param {number} gradient 指定所处粒子生命周期的阶段
         * @param {Vector4} speed 指定粒子速度的左区间
         * @param {Vector4} speed2 指定粒子速度的右区间
         */
        addSpeedScaleGradient(
            gradient: number,
            speed: number,
            speed2?: number
        ): void
        /**
         * 添加粒子运动过程中的速度限制规则。
         * @param {number} gradient 指定所处粒子生命周期的阶段
         * @param {number} limitSpeed 指定粒子限制速度的左区间
         * @param {number} limitSpeed2 指定粒子限制速度的右区间
         */
        addLimitSpeedGradient(
            gradient: number,
            limitSpeed: number,
            limitSpeed2?: number
        ): void
        /**
         * 添加粒子运动过程中的阻力规则。
         * @param {number} gradient 指定所处粒子生命周期的阶段
         * @param {number} speed 指定粒子受到的阻力大小的左区间[0-1]
         * @param {number} speed2 指定粒子受到的阻力大小的右区间[0-1]
         */
        addDragGradient(gradient: number, drag: number, drag2?: number): void
        /**
         * 添加粒子运动过程中的透明度变化规则。
         * @param {number} gradient 指定所处粒子生命周期的阶段
         * @param {number} alpha 指定粒子颜色透明度的左区间[0-1]
         * @param {number} alpha2 指定粒子颜色透明度的右区间[0-1]
         */
        addAlphaGradient(gradient: number, alpha: number, alpha2?: number): void
        /**
         * 添加粒子运动过程中的尺寸变化规则。
         * @param {number} gradient 指定所处粒子生命周期的阶段
         * @param {number} size 指定粒子尺寸的左区间
         * @param {number} size2 指定粒子尺寸的右区间
         */
        addSizeGradient(gradient: number, size: number, size2?: number): void
        /**
         * 添加粒子运动过程中的透明度变化范围。
         * @param {number} gradient 指定所处粒子生命周期的阶段
         * @param {number} min 指定粒子透明度值的左区间
         * @param {number} max 指定粒子透明度值的右区间
         */
        addColorRemapGradient(gradient: number, min: number, max?: number): void
        /**
         * 将存储不同时间段相关属性系数的数组按时间点从小到大进行排序。
         * @param {Array} factorGradients 存储不同时间段相关属性系数的数组
         * @param {number} gradient 一般代表粒子所处生命周期的阶段
         * @param {number} factor 左区间值
         * @param {number} factor2 右区间值
         */
        protected addFactorGradient(
            factorGradients: any,
            gradient: any,
            factor: any,
            factor2: any
        ): void
        /**
         * 添加粒子运动过程中的根据透明度影响的颜色变化规则，将通过颜色变化图纹理进行采样。
         * @param {number} gradient 指定粒子颜色变化图的具体位置，对应具体值应为(1-alpha)
         * @param {number} color 指定该位置的颜色
         */
        addRampGradient(gradient: any, color: any): void
        /**
         * 根据颜色变化数组，生成对应的颜色变化纹理
         */
        protected createRampGradientTexture(): void
        /**
         * @internal
         */
        protected lerpNumberArrayToVector(
            vector: any,
            numberArray1: any,
            numberArray2: any,
            step: any,
            length?: number
        ): void
    }
}

declare module 'XrFrame/components/AssetRenderTexture' {
    /**
     * AssetRenderTexture.ts
     *
     *         * @Date    : 8/29/2022, 11:27:00 AM
     */
    import Component, { IComponentSchema } from 'XrFrame/core/Component'
    import Element from 'XrFrame/core/Element'
    /**
     * `AssetRenderTexture`资源数据接口。
     */
    export interface IAssetRenderTextureData {
        assetId?: string
        width: number
        height: number
        isHDR?: boolean
    }
    /**
     * {@link AssetRenderTexture}的`schema`，详见{@link IAssetRenderTextureData}。
     */
    export const AssetRenderTextureSchema: IComponentSchema
    /**
     * 渲染纹理创建组件，用于在`xml`中创建{@link RenderTexture}资源，一般被代理到{@link XRAssetRenderTexture}元素。
     */
    export default class AssetRenderTexture extends Component<IAssetRenderTextureData> {
        /**
         * 详见{@link AssetRenderTextureSchema}。
         */
        readonly schema: IComponentSchema
        readonly isAssetRenderTexture: boolean
        onAdd(parent: Element, data: IAssetRenderTextureData): void
        /**
         * 移除AssetRenderTexture。
         */
        onRemove(parent: Element, data: IAssetRenderTextureData): void
    }
}

declare module 'XrFrame/components/Env' {
    /**
     * Env.ts
     *
     *         * @Date    : 5/11/2022, 5:21:48 PM
     */
    import { Kanata } from 'XrFrame/ext'
    import Component, { IComponentSchema } from 'XrFrame/core/Component'
    import EnvData from 'XrFrame/assets/EnvData'
    import Element from 'XrFrame/core/Element'
    import { ITextureWrapper } from 'XrFrame/core/DataValue'
    /**
     * {@link Env}组件数据接口。
     */
    export interface IEnvData {
        /**
         * 要使用的环境数据资源。
         * `xml`中的数据类型为`env-data`资源。
         */
        envData?: EnvData
        /**
         * 可以用于覆盖`envData`中的`skybox`。
         * `xml`中的数据类型为`texture`资源。
         */
        skyMap?: Kanata.Texture | ITextureWrapper
        /**
         * 是否用2D模式渲染天空盒，此时必须为`skyMap`必须**不**为`CubeTexture`。
         */
        isSky2D?: boolean
        /**
         * 环境旋转角度。
         * `xml`中的数据类型为`number`，默认为`0`。
         */
        rotation: number
        /**
         * 漫反射部分曝光。
         * `xml`中的数据类型为`number`，默认为`1`。
         */
        diffuseExp: number
        /**
         * 镜面反射部分曝光。
         * `xml`中的数据类型为`number`，默认为`1`。
         */
        specularExp: number
    }
    /**
     * {@link Env}的`schema`，详见{@link IEnvData}。
     */
    export const EnvSchema: IComponentSchema
    /**
     * 一般被代理到{@link XRARTracker}元素。
     */
    export default class Env extends Component<IEnvData> {
        /**
         * 详见{@link EnvSchema}。
         */
        readonly schema: IComponentSchema
        get useHalfSkyMap(): boolean
        get skyMap(): import('XrFrame/kanata/lib/index').Texture
        get isSky2D(): boolean
        get isSkyRT(): boolean
        get rotation(): number
        get hasDiffuse(): boolean
        get diffuseSH(): Float32Array
        get diffuseExp(): number
        get hasSpecular(): boolean
        get specularRGBD(): boolean
        get specularMipmaps(): boolean
        get specularMipmapCount(): number
        get specularMap(): import('XrFrame/kanata/lib/index').Texture
        get specularExp(): number
        onAdd(parent: Element, data: IEnvData): void
        onUpdate(data: IEnvData, preData: IEnvData): void
        onRemove(parent: Element, data: IEnvData): void
    }
}

declare module 'XrFrame/components/Animator' {
    /**
     * Animator.ts
     *
     *         * @Date    : 6/17/2022, 2:52:44 PM
     */
    import Component, { IComponentSchema } from 'XrFrame/core/Component'
    import Animation from 'XrFrame/animation/Animation'
    import Element from 'XrFrame/core/Element'
    type Scene = import('XrFrame/core/Scene').default
    /**
     * 使用`Animator`播放动画时可以传入的默认选项。
     */
    export interface IAnimationPlayOptions {
        /**
         * 播放速度，默认为`1`。
         */
        speed?: number
        /**
         * 循环次数，默认为`0`。
         */
        loop?: number
        /**
         * 播放延迟，默认为`0`。
         */
        delay?: number
        /**
         * 播放方向，默认为`forwards`。
         */
        direction?: 'forwards' | 'backwards' | 'both'
    }
    export enum EAnimationPlayState {
        Playing = 0,
        Paused = 1,
        Stopt = 2
    }
    /**
     * 自动播放配置。
     */
    export interface IAnimatorAutoPlay {
        /**
         * 片段名称。
         */
        clip?: string
        /**
         * 速度。
         */
        speed?: string
        /**
         * 循环次数。
         */
        loop?: string
        /**
         * 延迟。
         */
        delay?: string
        /**
         * 方向。
         */
        direction?: 'forwards' | 'backwards' | 'both'
        /**
         * 其他追加配置。
         */
        [key: string]: string | undefined
    }
    /**
     * {@link Animator}组件数据接口。
     */
    export interface IAnimatorData {
        /**
         * 默认的`Keyframe`动画资源。
         * `xml`中为资源id。
         */
        keyframe: Animation
        /**
         * 默认的片段名字映射，由于一个动画可以有多个片段，所以能通过映射由`Animator`中播放的名字 -> 动画资源中片段的名字。
         * `xml`中为`dict`数据。
         */
        clipMap?: {
            [key: string]: string
        }
        /**
         * 默认自动播放的参数，详见{@Link IAnimatorAutoPlay}。
         * `xml`中为`dict`数据。
         */
        autoPlay?: IAnimatorAutoPlay
    }
    /**
     * {@link Animator}的`schema`定义。
     * @see 解析后的接口详见 {@link IAnimatorData}
     */
    export const AnimatorSchema: {
        keyframe: {
            type: string
        }
        clipMap: {
            type: string
        }
        autoPlay: {
            type: string
        }
    }
    export default class Animator extends Component<IAnimatorData> {
        /**
         * 详见{@link AnimatorSchema}。
         */
        readonly schema: IComponentSchema
        readonly priority: number
        onAdd(parent: Element, data: IAnimatorData): void
        onUpdate(data: IAnimatorData, preData: IAnimatorData): void
        onRemove(parent: Element, data: IAnimatorData): void
        onRelease(data: IAnimatorData): void
        /**
         * 手动添加一个动画。
         *
         * @param clipMap 可选的动画片段名字映射。
         */
        addAnimation<T extends Animation>(
            anim: T,
            clipMap?: {
                [name: string]: string
            }
        ): T
        /**
         * 直接通过类`clz`和初始化数据`data`创建一个动画并添加到自身内。
         */
        createAnimation<T extends Animation>(
            clz: new (scene: Scene, data: T['__DATA_TYPE']) => T,
            data: T['__DATA_TYPE'],
            clipMap?: {
                [name: string]: string
            }
        ): T
        /**
         * 移除一个动画
         */
        removeAnimation(anim: Animation): void
        /**
         * @internal
         */
        /**
         * 播放一个动画片段，**可以同时播放多个片段**。
         *
         * @param name 动画片段名称。
         * @param options 播放选项。
         */
        play(
            name: string,
            options?: IAnimationPlayOptions & {
                [key: string]: any
            }
        ): void
        /**
         * 播放动画片段到某一进度并停下。
         *
         * @param name 片段名称。
         * @param progress 停到的某个进度，0~1。
         */
        pauseToFrame(name: string, progress: number): void
        /**
         * 暂停播放。
         *
         * @param name 需要暂停的片段，如果不填则暂停所有正在播放的片段。
         */
        pause(name?: string): void
        /**
         * 唤醒暂停的动画。
         *
         * @param name 需要唤醒的片段，如果不填则唤醒所有暂停的片段。
         */
        resume(name?: string): void
        /**
         * 停止播放。
         *
         * @param name 需要停止的片段，如果不填则停止所有正在播放的片段。
         */
        stop(name?: string): void
    }
    export {}
}

declare module 'XrFrame/components/CameraOrbitControl' {
    /**
     * CameraOrbitControl.ts
     *
     *         * @Date    : 5/19/2022, 1:22:59 PM
     */
    import Component, { IComponentSchema } from 'XrFrame/core/Component'
    import Element from 'XrFrame/core/Element'
    import Vector3 from 'XrFrame/math/vector3'
    /**
     * {@link CameraOrbitControl}组件数据接口。
     */
    export interface ICameraOrbitControlData {
        /**
         * 是否锁定横向旋转。
         */
        isLockX: boolean
        /**
         * 是否锁定纵向旋转。
         */
        isLockY: boolean
        /**
         * 是否锁定缩放。
         */
        isLockZoom: boolean
        /**
         * 是否锁定旋转。
         */
        isLockRotate: boolean
        /**
         * 是否锁定移动。
         */
        isLockMove: boolean
        /**
         * 允许的最大缩放值。
         */
        zoomMax: number
        /**
         * 允许的最小缩放值。
         */
        zoomMin: number
        /**
         * 平移速度。
         */
        panSpeed: number
        /**
         * 旋转速度。
         */
        rotateSpeed: number
        /**
         * 缩放速度。
         */
        zoomSpeed: number
        /**
         * 开启阻尼缓动。
         */
        enableDamping: boolean
        /**
         * 阻尼系数。
         */
        dampingFactor: number
    }
    /**
     * {@link CameraOrbitControl}的`schema`，详见{@link ICameraOrbitControlData}。
     */
    export const CameraOrbitControlSchema: IComponentSchema
    export default class CameraOrbitControl extends Component<ICameraOrbitControlData> {
        /**
         * 详见{@link CameraOrbitControlSchema}。
         */
        readonly schema: IComponentSchema
        /**
         * 是否锁定横向旋转。
         */
        isLockX: boolean
        /**
         * 是否锁定纵向旋转。
         */
        isLockY: boolean
        /**
         * 是否锁定缩放。
         */
        isLockZoom: boolean
        /**
         * 是否锁定旋转。
         */
        isLockRotate: boolean
        /**
         * 是否锁定移动。
         */
        isLockMove: boolean
        /**
         * 是否已经开启。
         */
        isEnabled: boolean
        /**
         * 允许的最大缩放值。
         */
        zoomMax: number
        /**
         * 允许的最小缩放值。
         */
        zoomMin: number
        /**
         * 允许的最大平移边界。
         */
        panMax: Vector3
        /**
         * 允许的最小平移边界。
         */
        panMin: Vector3
        /**
         * 平移速度。
         */
        panSpeed: number
        /**
         * 旋转速度。
         */
        rotateSpeed: number
        /**
         * 缩放速度。
         */
        zoomSpeed: number
        /**
         * 开启阻尼缓动。
         */
        enableDamping: boolean
        /**
         * 阻尼系数。
         */
        dampingFactor: number
        /**
         * 当前是否正在缓动。
         */
        get damping(): boolean
        /**
         * 获取当前目标。
         */
        get target(): Vector3
        /**
         * 添加到世界，继承请先`super.onAdd()`。
         */
        onAdd(parent: Element, data: ICameraOrbitControlData): void
        /**
         * 每一帧更新，继承请先`super.onUpdate()`。
         */
        onUpdate(data: ICameraOrbitControlData): void
        onTick(deltaTime: number, data: ICameraOrbitControlData): void
        /**
         * 销毁，继承请先`super.onUpdate()`。
         */
        onRemove(): void
        /**
         * 启动控制器。
         */
        enable(): void
        /**
         * 关闭控制器。
         */
        disable(): void
    }
}

declare module 'XrFrame/components/ARTracker' {
    /**
     * ARTracker.ts
     *
     *         * @Date    : 6/24/2022, 11:35:30 AM
     */
    import { Kanata } from 'XrFrame/ext'
    import Component, { IComponentSchema } from 'XrFrame/core/Component'
    import Element from 'XrFrame/core/Element'
    import Vector3 from 'XrFrame/math/vector3'
    /**
     * {@link ARSystem}和{@link ARTracker}的跟踪模式。
     */
    export type TTrackMode =
        | 'Plane'
        | 'Marker'
        | 'OSD'
        | 'Face'
        | 'Hand'
        | 'Body'
    /**
     * {@link ARTracker}的识别状态。
     * @version v2.29.1
     */
    export enum EARTrackerState {
        Init = 0,
        Detecting = 1,
        Detected = 2,
        Error = 3
    }
    /**
     * `Face`/`Body`/`Hand`模式下，{@link ARTracker}存储的原始数据类型。
     */
    export interface IARTrackerRawData {
        /**
         * 原点，屏幕空间。
         */
        origin: {
            x: number
            y: number
        }
        /**
         * 尺寸，屏幕空间。
         */
        size: {
            width: number
            height: number
        }
        /**
         * 置信度。
         */
        score: number
        /**
         * 在`Hand`模式下，手势分类，正常`0~18`，无效为`-1`。
         */
        gesture?: number
        /**
         * 在`Face`模式下，人脸旋转角度。
         */
        angle?: {
            pitch: number
            roll: number
            yaw: number
            z_score: number
        }
        /**
         * 关键点置信度。
         */
        confidence: number[]
        /**
         * 106个关键点，屏幕空间。
         */
        points: Array<{
            x: number
            y: number
        }>
    }
    /**
     * {@link ARTracker}组件数据接口。
     */
    export interface IARTrackerData {
        /**
         * 跟踪模式，必须在{@link ARSystem}已开启的模式列表中。
         * `xml`中数据为`string`类型。
         */
        mode: TTrackMode
        /**
         * 要追踪的图片资源，优先使用。
         * `xml`中数据为`image`类型。
         */
        image?: Kanata.IImage
        /**
         * 要追踪的图片地址，如果`image`没有定义，则使用这个。
         * `xml`中数据为`string`类型。
         */
        src?: string
        /**
         * 在`Face`模式下，给定一个**特征点索引**列表，详见官网对应文档。
         * 系统会自动同步位置和缩放到`ARTracker`下对应的顺序的子节点。
         * `-1`代表不同步位置，只同步缩放。
         */
        autoSync?: number[]
    }
    /**
     * {@link ARTracker}的`schema`，详见{@link IARTrackerData}。
     */
    export const ARTrackSchema: {
        mode: {
            type: string
        }
        image: {
            type: string
        }
        src: {
            type: string
        }
        autoSync: {
            type: string
        }
    }
    /**
     * AR追踪组件，配合{@link ARSystem}和{@link Camera}的`isARCamera`属性一起使用。
     * 一般被代理到{@link XRARTracker}元素。
     *
     * 其提供了追踪的能力，节点将会自动同步识别到的追踪目标的位置和旋转，
     */
    export default class ARTracker extends Component<IARTrackerData> {
        /**
         * 详见{@link ARTrackSchema}。
         */
        readonly schema: IComponentSchema
        /**
         * 跟踪模式。
         */
        get mode(): TTrackMode
        /**
         * 当前识别状态。
         *
         * @version v2.29.1
         */
        get state(): EARTrackerState
        /**
         * 如果为错误状态，错误信息。
         *
         * @version v2.29.1
         */
        get errorMessage(): string
        /**
         * 是否已经检测到了目标。
         */
        get arActive(): boolean
        /**
         * `Body`/`Hand`模式下，获取当前的置信度。
         * 一般为`0~1`。
         */
        get score(): number
        /**
         * 在`Hand`模式下，手势分类，正常`0~18`，无效为`-1`。
         */
        get gesture(): number
        /**
         * @internal
         */
        get filePath(): string
        /**
         * @internal
         */
        get trackId(): number
        onAdd(parent: Element, data: IARTrackerData): void
        onUpdate(data: IARTrackerData, preData: IARTrackerData): void
        onRemove(parent: Element, data: IARTrackerData): void
        /**
         * 在`Face`/`Body`/`Hand`模式下，获取某个特征点的位置。
         *
         * @param point 特征点索引，需要在`0~105`，否则返回`undefined`。
         * @param relativeToTracker 是否相对于`ARTracker`本身，默认为`true`，否则返回世界空间坐标。
         * @returns 只有在`arActive`时才有值，否则返回`undefined`。
         */
        getPosition(
            point: number,
            output?: Vector3,
            relativeToTracker?: boolean
        ): Vector3
        /**
         * @internal
         */
        /**
         * @internal
         */
    }
}

declare module 'XrFrame/components/physics/Shape' {
    import Component from 'XrFrame/core/Component'
    import Element from 'XrFrame/core/Element'
    import Vector3 from 'XrFrame/math/vector3'
    import { Kanata } from 'XrFrame/ext'
    import Rigidbody from 'XrFrame/components/physics/Rigidbody'
    import Mesh from 'XrFrame/components/Mesh'
    import GLTFComponent from 'XrFrame/components/GLTF'
    export const shapeMap: Map<phys3D.Collider, Shape>
    export enum EShapeType {
        /**
         * @internal
         */
        None = 0,
        /**
         * @see {@link CubeShape}
         */
        Cube = 1,
        /**
         * @internal
         */
        CharacterController = 2,
        /**
         * @see {@link CapsuleShape}
         */
        Capsule = 3,
        /**
         * @see {@link MeshShape}
         */
        Mesh = 4,
        /**
         * @see {@link SphereShape}
         */
        Sphere = 5
    }
    export enum ShapeImplType {
        None = 0,
        Basic = 1,
        AttachedToMesh = 2,
        GLTFMultiple = 3
    }
    export interface IShapeData {
        /**
         * 轮廓中心相对元素{@link Transform}中心的偏移量。
         * @default [0, 0, 0]
         */
        center?: [number, number, number]
        /**
         * 轮廓是否自动贴合{@link Mesh | Mesh组件}或{@link GLTF | GLTF组件}的大小。
         * 如果当前元素下不存在Mesh组件和GLTF组件则不生效。
         *
         * > {@link MeshShape}永远会开启这项。
         *
         * @default false
         */
        autoFit?: boolean
    }
    export const ShapeSchema: {
        center: {
            type: string
        }
        autoFit: {
            type: string
        }
    }
    /**
     * 轮廓组件的基类。
     * 为元素添加*该组件的子类*可以创建一个可用于交互的轮廓。
     *
     * > 💡 只要创建了轮廓，在点击该物体时就可以触发事件：
     * > + touch-shape: 点击物体事件，回调参数为{@link IShapeTouchEvent}；
     * > + drag-shape: 拖拽物体事件，回调参数为{@link IShapeDragEvent}；
     * > + untouch-shape: 松开物体事件，回调参数为{@link IShapeTouchEvent}；
     * >
     * > 绑定事件的方法可参考以下代码：
     * >
     * > ``` <xr-node sphere-shape bind:touch-shape="handleTouchShape"></xr-node> ```
     *
     * > 💡 如果想要将轮廓可视化来确认轮廓大小，可以在同一个元素下添加{@link ShapeGizmos}组件，或在标签上添加`shape-gizmo`属性（对MeshShape不起作用）。
     *
     * @abstract
     */
    export default abstract class Shape extends Component<IShapeData> {
        readonly priority: number
        _nativeStaticRigidbody: phys3D.Rigidbody | null
        _nativeColliders: phys3D.Collider[]
        protected _rigidbodyComp: Rigidbody | null
        protected _type: EShapeType
        protected _shadowShapes: Shape[]
        /**
         * @internal
         */
        get shadowShapes(): readonly Shape[]
        onAdd(parent: Element, data: IShapeData): void
        onUpdate(data: IShapeData, preData: IShapeData): void
        onTick(dateTime: number, data: IShapeData): void
        protected abstract _createBasic(data: IShapeData): void
        protected abstract _createAttachedToMesh(
            data: IShapeData,
            mesh: Mesh
        ): void
        protected abstract _createGLTFMultiple(
            data: IShapeData,
            gltf: GLTFComponent
        ): void
        /**
         * 无状态函数。
         */
        /**
         * 如果需要重建，那就重建。
         */
        onRemove(parent: Element, data: IShapeData): void
        onRelease(): void
        /**
         * @internal
         */
        get entity(): Kanata.Entity3D
        /**
         * 轮廓类型。
         */
        get type(): EShapeType
        set type(v: EShapeType)
        /**
         * @internal
         * 碰撞体是否是Trigger，开启后不参与碰撞，但是能触发Trigger系列的事件：
         * {@link onTriggerEnter}, {@link onTriggerStay}, {@link onTriggerExit}。
         * @default false
         */
        get isTrigger(): boolean
        set isTrigger(v: boolean)
        /**
         * @internal
         */
        get scale(): Vector3
        set scale(v: Vector3)
        /**
         * @internal
         * 获取碰撞体附着的刚体组件。
         * 目前不支持刚体，必定返回null。
         */
        get attachedRigidbody(): any
        /**
         * @internal
         * 设置碰撞体的contactOffset，必须为正数。
         * *一对*碰撞体，如果他们之间的最近距离小于他们的contactOffset之和，那么物理系统在一次*物理模拟*后就会产生一次碰撞。
         */
        get contactOffset(): number
        set contactOffset(v: number)
        /** @internal */
        constructor()
        /**
         * @internal
         */
        enable(): void
        /**
         * @internal
         */
        disable(): void
        /**
         * 交给子类重载实现
         * @deprecated
         */
        protected _create(data: IShapeData): void
        /** @internal */
        onAddRigidbody(rigidbody: Rigidbody): void
        /** @internal */
        onRemoveRigidbody(): void
        /**
         * @virtual 子类调用该方法之前必须确保_nativeCollider已经创建
         */
        protected _baseInit(): void
    }
}

declare module 'XrFrame/components/physics/SphereShape' {
    import Shape, {
        EShapeType,
        IShapeData
    } from 'XrFrame/components/physics/Shape'
    import Vector3 from 'XrFrame/math/vector3'
    import { IComponentSchema } from 'XrFrame/core/Component'
    import Mesh from 'XrFrame/components/Mesh'
    import GLTFComponent from 'XrFrame/components/GLTF'
    /**
     * @see {@link SphereShapes}
     */
    export interface ISphereShapeData extends IShapeData {
        /**
         * 球形轮廓的半径。
         * @default 1
         */
        radius?: number
    }
    export const SphereShapeSchema: IComponentSchema
    /**
     * 为当前元素创建一个可交互的球状轮廓。
     * 可通过在标签上添加`sphere-shape`属性来为元素添加该组件。
     *
     * @see {@link ISphereShapeData}
     */
    export default class SphereShape extends Shape {
        readonly schema: IComponentSchema
        protected _type: EShapeType
        /**
         * 轮廓相对于元素中心点的偏移量。
         */
        get center(): Vector3
        set center(v: Vector3)
        static defaultRadius: number
        /**
         * 球形轮廓的半径。
         */
        get radius(): number
        set radius(v: number)
        protected _createBasic(data: ISphereShapeData): void
        protected _createAttachedToMesh(
            data: ISphereShapeData,
            mesh: Mesh
        ): void
        protected _createGLTFMultiple(
            data: ISphereShapeData,
            gltf: GLTFComponent
        ): void
    }
}

declare module 'XrFrame/components/physics/MeshShape' {
    import Shape, {
        IShapeData,
        EShapeType
    } from 'XrFrame/components/physics/Shape'
    import { IComponentSchema } from 'XrFrame/xrFrameSystem'
    import GLTFComponent from 'XrFrame/components/GLTF'
    /**
     * @see {@link MeshShape}
     */
    export interface IMeshShapeData extends IShapeData {}
    export const MeshShapeSchema: IComponentSchema
    /**
     * 利用当前元素下的{@link Mesh | Mesh组件}或{@link GLTF | GLTF组件}，创建一个完全贴合的轮廓。如果当前元素下不存在Mesh组件或GLTF组件，则不生效。
     * 可通过在标签上添加`mesh-shape`属性来为元素添加该组件。
     *
     * > ⚠️ 如果Mesh或GLTF内部结构非常复杂，创建和维持该组件可能会占用较多的资源。如果发现该组件会导致小程序性能下降，可以考虑改用其他轮廓类型，并开启{@link IShapeData.autoFit | autoFit}属性。
     *
     * > ⚠️ MeshShape使用的Mesh的顶点数量不能超过65535个。如果超过了，推荐使用CubeShape+autoFit来代替。
     *
     * @see {@link IMeshShapeData}
     */
    export default class MeshShape extends Shape {
        readonly schema: IComponentSchema
        readonly priority: number
        _nativeColliders: phys3D.MeshCollider[]
        _shadowShapes: MeshShape[]
        protected _type: EShapeType
        protected _createBasic(data: IMeshShapeData): void
        protected _createAttachedToMesh(data: IMeshShapeData): void
        protected _createGLTFMultiple(
            data: IMeshShapeData,
            gltf: GLTFComponent
        ): void
    }
}

declare module 'XrFrame/components/physics/CapsuleShape' {
    import Shape, {
        EShapeType,
        IShapeData
    } from 'XrFrame/components/physics/Shape'
    import Vector3 from 'XrFrame/math/vector3'
    import { IComponentSchema } from 'XrFrame/xrFrameSystem'
    import Mesh from 'XrFrame/components/Mesh'
    import GLTFComponent from 'XrFrame/components/GLTF'
    /**
     * @see {@link CapsuleShape}
     */
    export interface ICapsuleShapeData extends IShapeData {
        /**
         * 胶囊体两端球体的半径。
         * @default 0.5
         */
        radius?: number
        /**
         * 胶囊体的长度。
         * @default 2
         */
        height?: number
        /**
         * 胶囊体的朝向。
         * @default ECapsuleShapeDirection["Y-Axis"]
         */
        direction?: ECapsuleShapeDirection
    }
    export const CapsuleShapeSchema: IComponentSchema
    /**
     * 胶囊体轮廓的朝向。
     *
     * @category Physics
     */
    export enum ECapsuleShapeDirection {
        'X-Axis' = 0,
        'Y-Axis' = 1,
        'Z-Axis' = 2
    }
    /**
     * 为当前元素创建一个可交互的胶囊体轮廓。
     * 可通过在标签上添加`capsule-shape`属性来为元素添加该组件。
     *
     * @see {@link ICapsuleShapeData}
     */
    export default class CapsuleShape extends Shape {
        readonly schema: IComponentSchema
        protected _type: EShapeType
        set center(v: Vector3)
        static defaultRadius: number
        /**
         * 胶囊体两端球体的半径。
         */
        get radius(): number
        set radius(v: number)
        static defaultHeight: number
        /**
         * 胶囊体的长度。
         */
        get height(): number
        set height(v: number)
        /**
         * 胶囊体的朝向。
         */
        get direction(): ECapsuleShapeDirection
        set direction(v: ECapsuleShapeDirection)
        protected _createBasic(data: ICapsuleShapeData): void
        protected _createAttachedToMesh(
            data: ICapsuleShapeData,
            mesh: Mesh
        ): void
        protected _createGLTFMultiple(
            data: ICapsuleShapeData,
            gltf: GLTFComponent
        ): void
    }
}

declare module 'XrFrame/components/physics/CubeShape' {
    import Shape, {
        EShapeType,
        IShapeData
    } from 'XrFrame/components/physics/Shape'
    import Vector3 from 'XrFrame/math/vector3'
    import { IComponentSchema } from 'XrFrame/xrFrameSystem'
    import Mesh from 'XrFrame/components/Mesh'
    import GLTFComponent from 'XrFrame/components/GLTF'
    /**
     * @see {@link CubeShape}
     */
    export interface ICubeShapeData extends IShapeData {
        /**
         * 长方体沿x,y,z轴的长度。
         * @default [1, 1, 1]
         */
        size?: [number, number, number]
    }
    export const CubeShapeSchema: IComponentSchema
    /**
     * 为当前元素创建一个可交互的长方体轮廓。
     * 可通过在标签上添加`cube-shape`属性来为元素添加该组件。
     *
     * @see {@link ICubeShapeData}
     */
    export default class CubeShape extends Shape {
        readonly schema: IComponentSchema
        protected _type: EShapeType
        /**
         * 轮廓相对于元素中心点的偏移量。
         */
        get center(): Vector3
        set center(v: Vector3)
        /**
         * 长方体沿x,y,z轴的长度。
         */
        get size(): Vector3
        set size(v: Vector3)
        protected _createBasic(data: ICubeShapeData): void
        protected _createAttachedToMesh(data: ICubeShapeData, mesh: Mesh): void
        protected _createGLTFMultiple(
            data: ICubeShapeData,
            gltf: GLTFComponent
        ): void
    }
}

declare module 'XrFrame/components/gizmo/ShapeGizmos' {
    import Component from 'XrFrame/core/Component'
    import Element from 'XrFrame/core/Element'
    import CapsuleGizmo from 'XrFrame/components/gizmo/CapsuleGizmo'
    import Shape, { ShapeImplType } from 'XrFrame/components/physics/Shape'
    import CubeGizmo from 'XrFrame/components/gizmo/CubeGizmo'
    /**
     * @see {@link ShapeGizmos}
     */
    export interface IShapeGizmosData {}
    export const ShapeGizmosSchema: {}
    interface GizmoInfo {
        shape: Shape
        gizmoCtor: null | typeof CubeGizmo | typeof CapsuleGizmo
        shadowGizmos: ShapeGizmos[]
        type: ShapeImplType
        version: number
    }
    /**
     * 将当前元素下的所有{@link Shape | 轮廓}都显示出来。
     * 在标签上添加`shape-gizmo`属性来创建该组件。
     *
     * @see {@link IShapeGizmosData}
     */
    export default class ShapeGizmos extends Component<IShapeGizmosData> {
        onAdd(parent: Element, data: IShapeGizmosData): void
        onUpdate(data: IShapeGizmosData, preData: IShapeGizmosData): void
        onTick(deltaTime: number, data: IShapeGizmosData): void
        onRemove(parent: Element, data: IShapeGizmosData): void
        onRelease(data: IShapeGizmosData): void
        /**
         * @internal
         */
        buildGizmo(info: GizmoInfo): void
    }
    export {}
}

declare module 'XrFrame/components/AssetPostProcess' {
    /**
     * AssetPostProcess.ts
     *
     *         * @Date    : 10/14/2022, 4:35:12 PM
     */
    import Component, { IComponentSchema } from 'XrFrame/core/Component'
    import Element from 'XrFrame/core/Element'
    /**
     * `AssetPostProcess`资源数据接口。
     */
    export interface IAssetPostProcessData {
        /**
         * 资源`id`。
         */
        assetId: string
        /**
         * 同{@link IPostProcessOptions.type}。
         */
        type: string
        /**
         * 同{@link IPostProcessOptions.isHDR}。
         */
        isHDR?: boolean
        /**
         * 同{@link IPostProcessOptions.data}。
         */
        data?: {
            [key: string]: string
        }
    }
    /**
     * {@link AssetPostProcess}的`schema`，详见{@link IAssetPostProcessData}。
     */
    export const AssetPostProcessSchema: IComponentSchema
    /**
     * 渲染纹理创建组件，用于在`xml`中创建{@link PostProcess}资源，一般被代理到{@link XRAssetPostProcess}元素。
     */
    export default class AssetPostProcess extends Component<IAssetPostProcessData> {
        /**
         * 详见{@link AssetPostProcessSchema}。
         */
        readonly schema: IComponentSchema
        /**
         * 对应后处理资源的数据，可用于修改。
         */
        get assetData(): {
            [key: string]: any
        }
        onAdd(parent: Element, data: IAssetPostProcessData): void
        onUpdate(
            data: IAssetPostProcessData,
            preData: IAssetPostProcessData
        ): void
        /**
         * 移除AssetPostProcess。
         */
        onRemove(parent: Element, data: IAssetPostProcessData): void
    }
}

declare module 'XrFrame/elements/xr-node' {
    /**
     * xr-node.ts
     *
     *         * @Date    : 2022/3/18下午2:15:02
     */
    import Element, { IEntityComponents } from 'XrFrame/core/Element'
    /**
     * 默认包含{@link Transform}组件。
     */
    export const NodeDefaultComponents: IEntityComponents
    /**
     * 默认将{@link Transform}组件的属性进行映射。
     */
    export const NodeDataMapping: {
        'node-id': string[]
        visible: string[]
        layer: string[]
        position: string[]
        rotation: string[]
        scale: string[]
    } & {
        [key: string]: string[]
    }
    /**
     * 标签为`xr-node`，场景中所有3D节点的基础。
     *
     * 默认组件见{@link NodeDefaultComponents}，属性映射见{@link NodeDataMapping}。
     */
    export default class XRNode extends Element {
        static IS(element: Element): element is XRNode
        readonly defaultComponents: IEntityComponents
        readonly dataMapping: {
            [key: string]: string[]
        }
        readonly isXRNode: boolean
    }
}

declare module 'XrFrame/elements/xr-shadow' {
    /**
     * xr-shadow.ts
     *
     *         * @Date    : 6/14/2022, 3:59:17 PM
     */
    import Element, { IEntityComponents } from 'XrFrame/core/Element'
    /**
     * 默认包含{@link XRNode}的所有默认组件。
     */
    export const ShadowDefaultComponents: IEntityComponents
    /**
     * 默认包含{@link XRNode}的所有属性映射。
     */
    export const ShadowDataMapping: {
        'node-id': string[]
        visible: string[]
        layer: string[]
        position: string[]
        rotation: string[]
        scale: string[]
    } & {
        [key: string]: string[]
    }
    /**
     * 标签为`xr-shadow`。
     * 是一种特殊的节点，开发者**仅可在其下以及子孙挂载自己创建的节点**！
     *
     * 默认组件见{@link ShadowDefaultComponents}，属性映射见{@link ShadowDataMapping}。
     */
    export default class XRShadow extends Element {
        readonly defaultComponents: IEntityComponents
        readonly dataMapping: {
            [key: string]: string[]
        }
        _appendChild(_child: Element, custom?: boolean): void
        _removeChild(_child: Element, _index?: number, custom?: boolean): void
        _insertBefore(_child: Element, _before?: Element, _index?: number): void
        _replaceChild(
            _child: Element,
            _oldChild?: Element,
            _index?: number
        ): void
        _spliceBefore(
            _before: number | Element,
            _deleteCount: number,
            _list: Element
        ): void
        _spliceAppend(_list: Element): void
        _spliceRemove(_before: Element, _deleteCount: number): void
    }
}

declare module 'XrFrame/elements/xr-camera' {
    /**
     * xr-camera.ts
     *
     *         * @Date    : 2022/3/29下午5:03:57
     */
    import Element, { IEntityComponents } from 'XrFrame/core/Element'
    /**
     * 默认包含{@link XRNode}的所有默认组件，以及{@link Camera}组件。
     */
    export const CameraDefaultComponents: IEntityComponents
    /**
     * 默认包含{@link XRNode}的所有属性映射，以及将{@link Camera}组件的属性进行映射。
     */
    export const CameraDataMapping: {
        target: string[]
        'render-target': string[]
        'is-perspective': string[]
        'cull-mask': string[]
        depth: string[]
        fov: string[]
        near: string[]
        far: string[]
        'orth-size': string[]
        background: string[]
        'is-ar-camera': string[]
        'is-clear-depth': string[]
        'is-clear-stencil': string[]
        'is-clear-color': string[]
        'clear-depth': string[]
        'clear-stencil': string[]
        'clear-color': string[]
        'post-process': string[]
    } & {
        'node-id': string[]
        visible: string[]
        layer: string[]
        position: string[]
        rotation: string[]
        scale: string[]
    } & {
        [key: string]: string[]
    }
    /**
     * 标签为`xr-camera`。
     *
     * 默认组件见{@link CameraDefaultComponents}，属性映射见{@link CameraDataMapping}。
     */
    export default class XRCamera extends Element {
        readonly defaultComponents: IEntityComponents
        readonly dataMapping: {
            [key: string]: string[]
        }
    }
}

declare module 'XrFrame/elements/xr-mesh' {
    /**
     * xr-mesh.ts
     *
     *         * @Date    : 2022/3/29下午5:05:49
     */
    import Element, { IEntityComponents } from 'XrFrame/core/Element'
    /**
     * 默认包含{@link XRNode}的所有默认组件，以及{@link Mesh}组件。
     */
    export const MeshDefaultComponents: IEntityComponents
    /**
     * 默认包含{@link XRNode}的所有属性映射，以及将{@link Mesh}组件的属性进行映射。
     */
    export const MeshDataMapping: {
        'never-cull': string[]
        'cast-shadow': string[]
        'receive-shadow': string[]
        geometry: string[]
        material: string[]
        uniforms: string[]
        states: string[]
    } & {
        'node-id': string[]
        visible: string[]
        layer: string[]
        position: string[]
        rotation: string[]
        scale: string[]
    } & {
        [key: string]: string[]
    }
    /**
     * 标签为`xr-mesh`。
     *
     * 默认组件见{@link MeshDefaultComponents}，属性映射见{@link MeshDataMapping}。
     */
    export default class XRMesh extends Element {
        readonly defaultComponents: IEntityComponents
        readonly dataMapping: {
            [key: string]: string[]
        }
    }
}

declare module 'XrFrame/elements/xr-light' {
    /**
     * xr-light.ts
     *
     *         * @Date    : 4/12/2022, 10:37:57 AM
     */
    import Element, { IEntityComponents } from 'XrFrame/core/Element'
    /**
     * 默认包含{@link XRNode}的所有默认组件，以及{@link Light}组件。
     */
    export const LightDefaultComponents: IEntityComponents
    /**
     * 默认包含{@link XRNode}的所有属性映射，以及将{@link Light}组件的属性进行映射。
     */
    export const LightDataMapping: {
        type: string[]
        'cast-shadow': string[]
        'shadow-distance': string[]
        'shadow-strength': string[]
        'shadow-bias': string[]
        color: string[]
        intensity: string[]
        range: string[]
        'inner-cone-angle': string[]
        'outer-cone-angle': string[]
    } & {
        'node-id': string[]
        visible: string[]
        layer: string[]
        position: string[]
        rotation: string[]
        scale: string[]
    } & {
        [key: string]: string[]
    }
    /**
     * 标签为`xr-ar-tracker`。
     *
     * 默认组件见{@link LightDefaultComponents}，属性映射见{@link LightDataMapping}。
     */
    export default class XRLight extends Element {
        readonly defaultComponents: IEntityComponents
        readonly dataMapping: {
            [key: string]: string[]
        }
    }
}

declare module 'XrFrame/elements/xr-gltf' {
    import { IEntityComponents } from 'XrFrame/core/Element'
    import XRShadow from 'XrFrame/elements/xr-shadow'
    /**
     * 默认包含{@link XRNode}的所有默认组件，以及{@link GLTF}组件。
     */
    export const GLTFDefaultComponents: IEntityComponents
    /**
     * 默认包含{@link XRNode}的所有属性映射，以及将{@link GLTF}组件的属性进行映射。
     *
     * + model → {@link IGLTFComponentData.model}
     * + cast-shadow → {@link IGLTFComponentData.castShadow}
     * + receive-shadow → {@link IGLTFComponentData.receiveShadow}
     *
     */
    export const GLTFDataMapping: {
        model: string[]
        'cast-shadow': string[]
        'receive-shadow': string[]
        'never-cull': string[]
        states: string[]
    } & {
        'node-id': string[]
        visible: string[]
        layer: string[]
        position: string[]
        rotation: string[]
        scale: string[]
    } & {
        [key: string]: string[]
    }
    /**
     * 标签为`xr-gltf`。
     *
     * 默认组件见{@link GLTFDefaultComponents}，属性映射见{@link GLTFDataMapping}。
     */
    export default class XRGLTF extends XRShadow {
        readonly defaultComponents: IEntityComponents
        readonly dataMapping: {
            [key: string]: string[]
        }
    }
}

declare module 'XrFrame/elements/xr-asset-material' {
    /**
     * xr-asset-material.ts
     *
     *         * @Date    : 2022/3/18下午5:27:37
     */
    import Element, { IEntityComponents } from 'XrFrame/core/Element'
    export const AssetMaterialDefaultComponents: IEntityComponents
    /**
     * 将{@link AssetMaterial}的属性进行映射。
     */
    export const AssetMaterialDataMapping: {
        'asset-id': string[]
        effect: string[]
        marcos: string[]
        uniforms: string[]
        states: string[]
        'render-queue': string[]
    } & {
        [key: string]: string[]
    }
    /**
     * 标签为`xr-asset-material`。
     *
     * 默认组件见{@link AssetMaterialDefaultComponents}，属性映射见{@link AssetMaterialDataMapping}。
     */
    export default class XRAssetMaterial extends Element {
        readonly defaultComponents: IEntityComponents
        readonly dataMapping: {
            [key: string]: string[]
        }
    }
}

declare module 'XrFrame/elements/xr-asset-render-texture' {
    /**
     * xr-asset-render-texture.ts
     *
     *         * @Date    : 8/29/2022, 12:51:29 PM
     */
    import Element, { IEntityComponents } from 'XrFrame/core/Element'
    export const AssetRenderTextureDefaultComponents: IEntityComponents
    /**
     * 将{@link AssetRenderTexture}的属性进行映射。
     */
    export const AssetRenderTextureDataMapping: {
        'asset-id': string[]
        width: string[]
        height: string[]
        'is-hdr': string[]
    } & {
        [key: string]: string[]
    }
    /**
     * 标签为`xr-asset-render-texture`。
     *
     * 默认组件见{@link AssetRenderTextureDefaultComponents}，属性映射见{@link AssetRenderTextureDataMapping}。
     */
    export default class XRAssetRenderTexture extends Element {
        readonly defaultComponents: IEntityComponents
        readonly dataMapping: {
            [key: string]: string[]
        }
    }
}

declare module 'XrFrame/elements/xr-asset-load' {
    /**
     * xr-asset-load.ts
     *
     *         * @Date    : 2022/3/16下午5:29:40
     */
    import Element from 'XrFrame/core/Element'
    /**
     * 将{@link AssetLoad}组件的属性进行映射。
     */
    export const AssetLoadDataMapping: {
        type: string[]
        'asset-id': string[]
        src: string[]
        defer: string[]
        options: string[]
    } & {
        [key: string]: string[]
    }
    /**
     * 标签为`xr-asset-load`。
     *
     * 属性映射见{@link AssetLoadDataMapping}。
     */
    export default class XRAssetLoad extends Element {
        readonly dataMapping: {
            [key: string]: string[]
        }
        readonly neverTick: boolean
    }
}

declare module 'XrFrame/elements/xr-assets' {
    /**
     * xr-assets.ts
     *
     *         * @Date    : 2022/3/16下午5:28:52
     */
    import Element, { IEntityComponents } from 'XrFrame/core/Element'
    /**
     * 默认包含{@link Assets}组件。
     */
    export const AssetsDefaultComponents: IEntityComponents
    /**
     * 标签为`xr-assets`。
     *
     * 默认组件见{@link AssetsDefaultComponents}。
     */
    export default class XRAssets extends Element {
        readonly defaultComponents: IEntityComponents
        readonly neverTick: boolean
    }
}

declare module 'XrFrame/elements/xr-env' {
    /**
     * xr-env.ts
     *
     *         * @Date    : 5/12/2022, 12:56:19 PM
     */
    import Element, { IEntityComponents } from 'XrFrame/core/Element'
    /**
     * 默认包含{@link Env}组件。
     */
    export const EnvDefaultComponents: IEntityComponents
    /**
     * 默认将{@link Env}组件的属性进行映射。
     */
    export const EnvDataMapping: {
        'env-data': string[]
        'sky-map': string[]
        'is-sky2d': string[]
        rotation: string[]
        'diffuse-exp': string[]
        'specular-exp': string[]
    } & {
        [key: string]: string[]
    }
    /**
     * 标签为`xr-env`。
     *
     * 默认组件见{@link EnvDefaultComponents}，属性映射见{@link EnvDataMapping}。
     */
    export default class XREnv extends Element {
        readonly defaultComponents: IEntityComponents
        readonly dataMapping: {
            [key: string]: string[]
        }
        readonly neverTick: boolean
    }
}

declare module 'XrFrame/elements/xr-ar-tracker' {
    /**
     * xr-ar-tracker.ts
     *
     *         * @Date    : 6/27/2022, 3:42:45 PM
     */
    import Element, { IEntityComponents } from 'XrFrame/core/Element'
    /**
     * 默认包含{@link XRNode}的所有默认组件，以及{@link ARTracker}组件。
     */
    export const ARTrackerDefaultComponents: IEntityComponents
    /**
     * 默认包含{@link XRNode}的所有属性映射，以及将{@link ARTracker}组件的属性进行映射。
     */
    export const ARTrackerDataMapping: {
        mode: string[]
        'hit-id': string[]
        image: string[]
        src: string[]
        'auto-sync': string[]
    } & {
        'node-id': string[]
        visible: string[]
        layer: string[]
        position: string[]
        rotation: string[]
        scale: string[]
    } & {
        [key: string]: string[]
    }
    /**
     * 标签为`xr-ar-tracker`。
     *
     * 默认组件见{@link ARTrackerDefaultComponents}，属性映射见{@link ARTrackerDataMapping}。
     */
    export default class XRARTracker extends Element {
        readonly defaultComponents: IEntityComponents
        readonly dataMapping: {
            [key: string]: string[]
        }
    }
}

declare module 'XrFrame/elements/xr-text' {
    import Element, { IEntityComponents } from 'XrFrame/core/Element'
    export const TextDefaultComponents: IEntityComponents
    export const TextDataMapping: {
        [key: string]: string[]
    }
    export default class XRText extends Element {
        readonly defaultComponents: IEntityComponents
        readonly dataMapping: {
            [key: string]: string[]
        }
    }
}

declare module 'XrFrame/elements/xr-particle' {
    import Element, { IEntityComponents } from 'XrFrame/core/Element'
    export const ParticleDefaultComponents: IEntityComponents
    export const ParticleDataMapping: {
        [key: string]: string[]
    }
    export default class XRParticle extends Element {
        readonly defaultComponents: IEntityComponents
        readonly dataMapping: {
            [key: string]: string[]
        }
    }
}

declare module 'XrFrame/elements/xr-asset-post-process' {
    /**
     * xr-asset-post-process.ts
     *
     *         * @Date    : 10/14/2022, 5:18:21 PM
     */
    import Element, { IEntityComponents } from 'XrFrame/core/Element'
    export const AssetPostProcessDefaultComponents: IEntityComponents
    /**
     * 将{@link AssetPostProcess}的属性进行映射。
     */
    export const AssetPostProcessDataMapping: {
        'asset-id': string[]
        type: string[]
        'is-hdr': string[]
        data: string[]
    } & {
        [key: string]: string[]
    }
    /**
     * 标签为`xr-asset-render-texture`。
     *
     * 默认组件见{@link AssetPostProcessDefaultComponents}，属性映射见{@link AssetPostProcessDataMapping}。
     */
    export default class XRAssetPostProcess extends Element {
        readonly defaultComponents: IEntityComponents
        readonly dataMapping: {
            [key: string]: string[]
        }
    }
}

declare module 'XrFrame/systems/AssetsSystem' {
    import Component from 'XrFrame/core/Component'
    import Element from 'XrFrame/core/Element'
    import { IAssetLoadData, IAssetWithState } from 'XrFrame/loader/types'
    export interface IAssetsSystemData {}
    /**
     * 资源系统，负责整个场景的资源管理。
     *
     * 一般不需要手动管理，而是利用{@link AssetLoad}、{@link registerGeometry}之类的使用。
     */
    export default class AssetsSystem extends Component<IAssetsSystemData> {
        readonly priority: number
        /**
         * 手动添加一个资源。
         */
        addAsset<T>(type: string, id: string, asset: T): void
        /**
         * 手动加载一个资源。
         */
        loadAsset(
            params: IAssetLoadData,
            parent?: Element
        ): Promise<IAssetWithState<any>>
        /**
         * 手动释放一个资源。
         *
         * 注意在`xml`里加载的资源不要手动释放。
         */
        releaseAsset(type: string, id: string): void
        /**
         * 获取一个资源，如果尚未加载完成，也会返回`undefined`。
         */
        getAsset<T>(type: string, id: string, fallback?: string): T
        /**
         * 获取一个资源以及加载状态。
         */
        getAssetWithState<T>(
            type: string,
            id: string,
            fallback?: string
        ): IAssetWithState<T>
        /**
         * 取消加载一个资源。
         */
        cancelAsset(type: string, id: string): void
        /**
         * @internal
         */
        /**
         * @internal
         */
        onRelease(data: IAssetsSystemData): void
    }
}

declare module 'XrFrame/systems/NodeSystem' {
    import Component from 'XrFrame/core/Component'
    export interface INodeSystemData {}
    /**
     * 节点系统，负责整个场景节点的管理。
     */
    export default class NodeSystem extends Component<INodeSystemData> {
        readonly priority: number
        onTick(deltaTime: number, data: INodeSystemData): void
    }
}

declare module 'XrFrame/systems/TickSystem' {
    /**
     * TickSystem.ts
     *
     *         * @Date    : 2022/3/29上午10:50:57
     */
    import Component from 'XrFrame/core/Component'
    export interface ITickSystemData {}
    /**
     * Tick系统，负责整个场景生命周期的驱动。
     */
    export default class TickSystem extends Component<ITickSystemData> {
        readonly priority: number
        onTick(deltaTime: number, data: ITickSystemData): void
    }
}

declare module 'XrFrame/systems/AnimationSystem' {
    /**
     * AnimationSystem.ts
     *
     *         * @Date    : 6/17/2022, 2:35:17 PM
     */
    import Animator from 'XrFrame/components/Animator'
    import Component from 'XrFrame/core/Component'
    export interface IAnimationSystemData {}
    /**
     * 动画系统，负责整个场景动画的管理。
     */
    export default class AnimationSystem extends Component<IAnimationSystemData> {
        readonly priority: number
        onTick(deltaTime: number, data: IAnimationSystemData): void
        /**
         * @internal
         */
        /**
         * @internal
         */
    }
}

declare module 'XrFrame/systems/VideoSystem' {
    /**
     * VideoSystem.ts
     *
     *         * @Date    : 8/26/2022, 8:02:21 PM
     */
    import VideoTexture from 'XrFrame/assets/VideoTexture'
    import Component from 'XrFrame/core/Component'
    export interface IVideoSystemData {}
    /**
     * 视频系统，负责整个场景视频的管理。
     */
    export default class VideoSystem extends Component<IVideoSystemData> {
        readonly priority: number
        onTick(deltaTime: number, data: IVideoSystemData): void
        /**
         * @internal
         */
        /**
         * @internal
         */
    }
}

declare module 'XrFrame/systems/RenderSystem' {
    /**
     * RenderSystem.ts
     *
     *         * @Date    : 2022/3/16下午4:20:58
     */
    import Component, { IComponentSchema } from 'XrFrame/core/Component'
    import Element from 'XrFrame/core/Element'
    import Camera from 'XrFrame/components/Camera'
    import Env from 'XrFrame/components/Env'
    import RenderGraph from 'XrFrame/render-graph/RenderGraph'
    import LightManager from 'XrFrame/systems/LightManager'
    import Observable from 'XrFrame/core/Observable'
    /**
     * `RenderSystem`系统数据接口。
     */
    export interface IRenderSystemData {
        /**
         * 场景中阴影的颜色。
         * `xml`中数据类型为`color`。
         */
        shadowColor: number[]
    }
    /**
     * {@link RenderSystem}的`schema`，详见{@link IRenderSystemData}。
     */
    export const RenderSystemSchema: IComponentSchema
    /**
     * 渲染系统，负责整个场景渲染的管理。
     */
    export default class RenderSystem extends Component<IRenderSystemData> {
        readonly priority: number
        /**
         * 详见{@link RenderSystemSchema}。
         */
        readonly schema: IComponentSchema
        protected _lights: LightManager
        protected _renderGraph?: RenderGraph
        protected _sortedCameras: Camera[]
        protected _dirtyCameras: Camera[]
        protected _camerasChangeEvent: Observable<this>
        protected _env: Env
        /**
         * @internal
         */
        get lights(): LightManager
        /**
         * @internal
         */
        get env(): Env
        /**
         * @internal
         */
        get camerasChangeEvent(): Observable<this, any>
        /**
         * 获取场景中的所有相机，已按照深度排序。
         *
         * @internal
         */
        get cameras(): Camera[]
        /**
         * 获取场景中的所有当帧修改过的相机，已按照深度排序。
         *
         * @internal
         */
        get changedCameras(): Camera[]
        /**
         * 当前正在使用的RenderGraph。
         */
        get renderGraph(): RenderGraph<any>
        get shadowColor(): number[]
        /**
         * 修改全局宏信息。
         */
        changeMacros(macros: {
            [name: string]: string | number | boolean
        }): void
        /**
         * 获取全局宏信息。
         */
        getMacro(key: string): string | number | boolean
        onAdd(parent: Element, data: IRenderSystemData): void
        onTick(): void
        onRelease(data: IRenderSystemData): void
        /**
         * 使用某个RenderGraph，默认会使用内置的`ForwardBaseRG`。
         */
        useRenderGraph(rg: RenderGraph): void
        /**
         * 开启全局GPU实例化。
         */
        enableInstance(): void
        /**
         * 关闭全局GPU实例化。
         */
        disableInstance(): void
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * @internal
         */
        protected _sortCameras(): void
    }
}

declare module 'XrFrame/systems/PhysicsSystem' {
    import { Camera } from 'XrFrame/components'
    import Component from 'XrFrame/core/Component'
    import { Kanata } from 'XrFrame/ext'
    import { RaycastDesc } from 'XrFrame/physics/raycast'
    import Element from 'XrFrame/core/Element'
    import Shape from 'XrFrame/components/physics/Shape'
    /**
     * `touch-shape`和`untouch-shape`事件的回调参数。
     */
    export interface IShapeTouchEvent {
        /**
         * 渲染*被选中的{@link Shape | 轮廓}*的相机。
         */
        camera: Camera
        /**
         * *被选中的{@link Shape | 轮廓}*所在的元素。
         */
        target: Element
        /**
         * 被选中的{@link Shape | 轮廓}。
         */
        shape: Shape
        /**
         * 点击位置在二维canvas中的x坐标。
         */
        x: number
        /**
         * 点击位置在二维canvas中的y坐标。
         */
        y: number
        /**
         * {@link camera}在三维场景中的位置。
         */
        origin: [number, number, number]
        /**
         * 从{@link camera}投射出的射线的单位向量。
         */
        dir: [number, number, number]
        /**
         * @unimplemented
         */
        force: number
    }
    /**
     * `drag-shape`事件的回调参数。
     */
    export interface IShapeDragEvent extends IShapeTouchEvent {
        /**
         * 点击位置在二维canvas中的x坐标的变化量。
         */
        deltaX: number
        /**
         * 点击位置在二维canvas中的y坐标的变化量。
         */
        deltaY: number
    }
    /**
     * @see {@link PhysicsSystem}
     */
    export interface IPhysicsSystemData {}
    /**
     * 物理系统，管理着场景中的所有{@link Shape | 轮廓}。
     */
    export default class PhysicsSystem extends Component<IPhysicsSystemData> {
        /**
         * @internal
         */
        nativeSystem: phys3D.PhysSystem
        constructor()
        /** @internal */
        addShape(shape: Shape): void
        /** @internal */
        removeShape(shape: Shape): void
        onAdd(): void
        onTick(deltaTime: number, data: IPhysicsSystemData): void
        /**
         * @internal
         */
        bindRigidbodyWithEntity(
            rigidbody: phys3D.Rigidbody,
            entity: Kanata.Entity3D
        ): void
        /**
         * @internal
         * 射线检测，判断给定射线是否与至少一个碰撞体相交，并返回与**最近**的那个碰撞体相交的信息。
         */
        raycast(desc: RaycastDesc): boolean
    }
}

declare module 'XrFrame/systems/ARSystem' {
    import { Camera, Mesh } from 'XrFrame/components'
    import ARTracker, { TTrackMode } from 'XrFrame/components/ARTracker'
    import Component, { IComponentSchema } from 'XrFrame/core/Component'
    import Matrix4 from 'XrFrame/math/matrix4'
    import Vector3 from 'XrFrame/math/vector3'
    type Element = import('XrFrame/core/Element').default
    /**
     * AR追踪原始数据。
     */
    export interface IARRawData {
        /**
         * 当前相机帧画面宽度。
         */
        width: number
        /**
         * 当前相机帧画面高度。
         */
        height: number
        /**
         * 当前相机帧画面`y`通道，yuv420。
         */
        yBuffer: ArrayBuffer
        /**
         * 当前相机帧画面`uv`通道，yuv420。
         */
        uvBuffer: ArrayBuffer
        /**
         * 当前相机帧内参矩阵。
         */
        intrinsics: Float32Array
        /**
         * 当前相机帧视图矩阵。
         */
        viewMatrix: Float32Array
    }
    /**
     * `ARSystem`系统数据接口。
     */
    export interface IARSystemData {
        /**
         * 系统支持的追踪模式，目前仅支持一个！
         * `xml`中数据类型为`array`，默认值为`Plane`。
         */
        modes: TTrackMode[]
        /**
         * 使用前置还是后置相机，默认后置`Back`。
         */
        camera?: 'Front' | 'Back'
    }
    /**
     * {@link ARSystem}的`schema`，详见{@link IARSystemData}。
     */
    export const ARSystemSchema: IComponentSchema
    /**
     * AR系统，负责整个场景AR相关对象的管理。
     *
     * 代理自小程序的`VKSession`。
     */
    export default class ARSystem extends Component<IARSystemData> {
        /**
         * 详见{@link ARSystemSchema}。
         */
        readonly schema: IComponentSchema
        readonly priority: number
        /**
         * 当前设备是否启动成功。
         */
        get supported(): boolean
        /**
         * 当前启动的追踪模式。
         */
        get arModes(): TTrackMode[]
        /**
         * 当前启动的AR系统版本。
         */
        get arVersion(): number
        /**
         * 当前是否已经可用。
         */
        get ready(): boolean
        /**
         * 在`Face`/`Body`/`Hand`模式下，当前识别到的姿态数量。
         */
        get posCount(): number
        onAdd(parent: Element, data: IARSystemData): void
        onTick(deltaTime: number, data: IARSystemData): void
        onRemove(parent: Element, data: IARSystemData): void
        onRelease(data: IARSystemData): void
        /**
         * 在`Plane`模式下，同步某个节点到当前追踪到的和平面的交点。
         *
         * @param nodeIdOrElement 节点的`nodeId`或是`element`引用。
         * @param switchVisible 是否要自动切换显示或隐藏。
         * @returns 是否放置成功
         */
        placeHere(
            nodeIdOrElement: string | Element,
            switchVisible?: boolean
        ): boolean
        /**
         * 在`Plane`模式下，重置平面。
         */
        resetPlane(): void
        /**
         * 获取AR的追踪的原始数据。
         */
        getARRawData(): IARRawData
        /**
         * 提供一个修改某个设置为`isARCamera`的相机的试图矩阵的手段。
         */
        forceSetViewMatrix(camera: Camera, mat: Matrix4 | null): void
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * @internal
         */
    }
    export {}
}

declare module 'XrFrame/systems/ShareSystem' {
    /**
     * ShareSystem.ts
     *
     *         * @Date    : 9/19/2022, 5:04:24 PM
     */
    import Component from 'XrFrame/core/Component'
    export interface IShareSystemData {}
    /**
     * 分享到临时文件的配置。
     */
    export interface IShareCaptureOptions {
        /**
         * 输出图片编码。
         * @default 'jpg'
         */
        fileType?: 'jpg' | 'png'
        /**
         * 输出图片jpg时的品质，0~1。
         * @default 0.8
         */
        quality?: number
    }
    /**
     * 分享系统，负责分享相关功能。
     */
    export default class ShareSystem extends Component<IShareSystemData> {
        readonly priority: number
        /**
         * 当前是否支持分享系统。
         */
        get supported(): boolean
        /**
         * 截屏输出为`base64`。
         */
        captureToDataURL(options?: IShareCaptureOptions): string
        /**
         * 截屏输出为`ArrayBuffer`。
         */
        captureToArrayBuffer(options?: IShareCaptureOptions): ArrayBuffer
        /**
         * 截屏输出为本地路径，回调完成后会自动释放。
         *
         * @params callback 接受结果的回调，处理完后会释放文件。在v2.27.1前是异步，之后兼容同步和异步。
         */
        captureToLocalPath(
            options: IShareCaptureOptions,
            callback: (fp: string) => Promise<void> | void
        ): void
        /**
         * 直接截屏分享给好友。
         */
        captureToFriends(options?: IShareCaptureOptions): void
    }
}

declare module 'XrFrame/systems/GizmoSystem' {
    /**
     * @author shanexyzhou@tencent.com
     */
    import CapsuleGizmo from 'XrFrame/components/gizmo/CapsuleGizmo'
    import CubeGizmo from 'XrFrame/components/gizmo/CubeGizmo'
    import Component from 'XrFrame/core/Component'
    import Element from 'XrFrame/core/Element'
    export interface IGizmoSystemData {}
    type GizmoComponent = CubeGizmo | CapsuleGizmo
    /**
     * 动画系统，负责为Gizmo组件创建管理相对应的GizmoMesh元素。
     */
    export default class GizmoSystem extends Component<IGizmoSystemData> {
        readonly priority: number
        onTick(deltaTime: number, data: IGizmoSystemData): void
        /**
         * @internal
         * 因为exparser的原因，不能通过脚本为普通xml节点添加子节点，
         * 只能给XRShadow添加子节点，所以把需要添加gizmo的节点复制一份放在shadowRoot下，
         * 每帧去同步transform。
         */
        addGizmo(gizmo: GizmoComponent): Element
        /**
         * @internal
         */
        removeGizmo(gizmo: GizmoComponent): void
    }
    export {}
}

declare module 'XrFrame/loader/AssetLoader' {
    import { IAssetLoadData } from 'XrFrame/loader/types'
    type Scene = import('XrFrame/core/Scene').default
    /**
     * 指定继承自{@link AssetLoader}的自定义资源加载器，可以接受的的额外配置的`schema`。
     * 在基础库版本**v2.29.2**以上导出。
     *
     * 比如使用{@link CubeTextureLoader}加载资源时：
     *
     * ```xml
     * <xr-asset-load
     *   type="cube-texture" asset-id="sky-cube" src="/assets/textures/skybox/"
     *   options="faces: right.jpg left.jpg top.jpg bottom.jpg front.jpg back.jpg"
     * />
     * ```
     *
     * 对应的`schema`接口为：
     * ```ts
     * export interface ICubeTextureLoaderOptions {
     *   // left right top bottom front back
     *   faces: string[];
     * }
     * ```ts
     *
     * 对应的`schema`为：
     * ```ts
     * schema = {
     *   faces: {type: 'array'}
     * };
     * ```
     */
    export interface ILoaderOptionsSchema {
        [key: string]: {
            type: string
            defaultValue?: any
        }
    }
    /**
     * 资源加载器的基类，配合{@link AssetsSystem}使用。
     * 在基础库版本**v2.29.2**以上导出。
     *
     * @template T 加载资源的类型。
     * @template ILoadOptions 可接受额外配置的类型。
     */
    export default class AssetLoader<T, ILoadOptions> {
        /**
         * 和{@link Component.schema}类似，指定解析Options的实际`schema`，对应于`ILoadOptions`。
         */
        readonly schema: ILoaderOptionsSchema
        /**
         * 当前资源所属场景的实例。
         */
        get scene(): import('XrFrame/core/Scene').default
        constructor(_scene: Scene, type: string)
        /**
         * @internal
         */
        /**
         * 加载一个资源，并根据情况执行`callbacks`中的回调。
         * **理论上必须要实现！**
         *
         * @param callbacks 开发者需要在加载进度更新时执行`onLoading`，在加载完成时执行`onLoaded`，在加载出错是执行`onError`
         */
        load(
            data: IAssetLoadData<ILoadOptions>,
            callbacks: {
                onLoading(progress: number): void
                onLoaded(result: T, localPath?: string): void
                onError(error: Error): void
            }
        ): void
        /**
         * 取消加载特定资源。一般不需要自己编写逻辑，而是使用`entity.canceled`在加载终点丢弃。
         * 注意`entity.canceled`是在这里赋值的，所以一般继承请务必先执行`super.cancel()`！
         */
        cancel(params: IAssetLoadData<ILoadOptions>): void
        /**
         * 释放资源时将会调用，用于自定义释放逻辑。
         */
        release(params: IAssetLoadData<ILoadOptions>, value: T): void
        /**
         * 返回默认资源列表。
         * 所有默认资源都是惰性加载的。
         */
        getBuiltin(): Array<{
            assetId: string
            src: string
            options: ILoadOptions
        }>
    }
    export function getAssetLoaderTypes(): string[]
    export function getAssetLoader(
        type: string
    ): new (
        scene: import('XrFrame/core/Scene').default,
        type: string
    ) => AssetLoader<any, any>
    /**
     * 注册一个资源加载器。注意注册后该`type`会被自动注册到DataValue中：{@link registerDataValue}。
     * 在基础库版本**v2.29.2**以上导出。
     *
     * @param type 类型，也是写在{@link AssetLoad}上的那个`type`。
     * @param clz 继承自{@link AssetLoader}的自定义资源加载器类。
     */
    export function registerAssetLoader(
        type: string,
        clz: new (scene: Scene, type: string) => AssetLoader<any, any>
    ): void
    export {}
}

declare module 'XrFrame/loader/TextureLoader' {
    /**
     * TextureLoader.ts
     *
     *         * @Date    : 2022/4/1下午5:19:36
     */
    import { Kanata } from 'XrFrame/ext'
    import AssetLoader, {
        ILoaderOptionsSchema
    } from 'XrFrame/loader/AssetLoader'
    import { IAssetLoadData } from 'XrFrame/loader/types'
    export function isPOT(img: Kanata.IImage): boolean
    /**
     * {@link TextureLoader}可接受的自定义参数`schema`。
     */
    export interface ITextureLoaderOptions {
        /**
         * 各向异性系数。
         * @default 1
         */
        anisoLevel?: number
        /**
         * wrapU，值为数字，见{@link EWrapMode}。
         * @default 2
         */
        wrapU?: number
        /**
         * wrapV，值为数字，见{@link EWrapMode}。
         * @default 2
         */
        wrapV?: number
        /**
         * magFilter，值为数字，见{@link EFilterMode}。
         * 默认值依据纹理是否POT而定。
         */
        magFilter?: number
        /**
         * minFilter，值为数字，见{@link EFilterMode}。
         * 默认值依据纹理是否POT而定。
         */
        minFilter?: number
        /**
         * 是否要生成mipmaps。
         * @default false
         */
        generateMipmaps?: boolean
    }
    type ITextureLoadData = IAssetLoadData<ITextureLoaderOptions>
    /**
     * 纹理资源{@link Texture}的加载器。
     *
     * 内置资源可以通过{@link registerTexture}注册，拥有内置资源`brdf-lut`、`white`、`transparent`、`black`、`red`、`green`、`blue`、`yellow`、`babyblue`、`babygreen`、`babyred`。
     */
    export default class TextureLoader extends AssetLoader<
        Kanata.Texture,
        ITextureLoaderOptions
    > {
        readonly schema: ILoaderOptionsSchema
        load(
            params: ITextureLoadData,
            callbacks: {
                onLoading(progress: number): void
                onLoaded(value: Kanata.Texture): void
                onError(error: Error): void
            }
        ): void
        getBuiltin(): Array<{
            assetId: string
            src: string
            options: {}
        }>
        release(params: ITextureLoadData, value: Kanata.Texture): void
    }
    export {}
}

declare module 'XrFrame/loader/ImageLoader' {
    /**
     * ImageLoader.ts
     *
     *         * @Date    : 6/13/2022, 12:40:11 PM
     */
    import { Kanata } from 'XrFrame/ext'
    import AssetLoader, {
        ILoaderOptionsSchema
    } from 'XrFrame/loader/AssetLoader'
    import { IAssetLoadData } from 'XrFrame/loader/types'
    export interface IImageLoaderOptions {}
    type IImageLoadData = IAssetLoadData<IImageLoaderOptions>
    /**
     * 图片数据资源{@link IImage}的加载器。
     *
     * 图片数据不同于纹理资源{@link Texture}，请自行按照场景使用。
     */
    export default class ImageLoader extends AssetLoader<
        Kanata.IImage,
        IImageLoaderOptions
    > {
        readonly schema: ILoaderOptionsSchema
        load(
            params: IImageLoadData,
            callbacks: {
                onLoading(progress: number): void
                onLoaded(value: Kanata.IImage): void
                onError(error: Error): void
            }
        ): void
        release(params: IImageLoadData, value: Kanata.IImage): void
    }
    export {}
}

declare module 'XrFrame/loader/CubeTextureLoader' {
    /**
     * CubeCubeTextureLoader.ts
     *
     *         * @Date    : 5/10/2022, 11:24:51 AM
     */
    import { Kanata } from 'XrFrame/ext'
    import AssetLoader, {
        ILoaderOptionsSchema
    } from 'XrFrame/loader/AssetLoader'
    import { IAssetLoadData } from 'XrFrame/loader/types'
    /**
     * {@link CubeTextureLoader}可接受的自定义参数`schema`。
     */
    export interface ICubeTextureLoaderOptions {
        /**
         * 顺序为 left right top bottom front back。
         */
        faces: string[]
        /**
         * 各向异性系数。
         * @default 1
         */
        anisoLevel: number
        /**
         * wrapU，值为数字，见{@link EWrapMode}。
         * @default 2
         */
        wrapU?: number
        /**
         * wrapV，值为数字，见{@link EWrapMode}。
         * @default 2
         */
        wrapV?: number
        /**
         * wrapW，值为数字，见{@link EWrapMode}。
         * @default 2
         */
        wrapW?: number
        /**
         * magFilter，值为数字，见{@link EFilterMode}。
         * 默认值依据纹理是否POT而定。
         */
        magFilter?: number
        /**
         * minFilter，值为数字，见{@link EFilterMode}。
         * 默认值依据纹理是否POT而定。
         */
        minFilter?: number
        /**
         * 是否要生成mipmaps。
         * @default false
         */
        generateMipmaps?: boolean
    }
    type ICubeTextureLoadData = IAssetLoadData<ICubeTextureLoaderOptions>
    /**
     * 立方体资源{@link CubeTexture}的加载器。
     *
     * 内置资源可以通过{@link registerTextureCube}注册，拥有内置资源`brdf-lut`、`white`、`transparent`、`black`、`red`、`green`、`blue`、`yellow`。
     */
    export default class CubeTextureLoader extends AssetLoader<
        Kanata.Texture,
        ICubeTextureLoaderOptions
    > {
        /**
         * 详见{@link ICubeTextureLoaderOptions}。
         */
        readonly schema: ILoaderOptionsSchema
        load(
            params: ICubeTextureLoadData,
            callbacks: {
                onLoading(progress: number): void
                onLoaded(value: Kanata.Texture): void
                onError(error: Error): void
            }
        ): void
        release(params: ICubeTextureLoadData, value: Kanata.Texture): void
    }
    export {}
}

declare module 'XrFrame/loader/VideoTextureLoader' {
    /**
     * VideoTextureLoader.ts
     *
     *         * @Date    : 8/26/2022, 8:02:51 PM
     */
    import VideoTexture from 'XrFrame/assets/VideoTexture'
    import AssetLoader, {
        ILoaderOptionsSchema
    } from 'XrFrame/loader/AssetLoader'
    import { IAssetLoadData } from 'XrFrame/loader/types'
    /**
     * {@link VideoTextureLoader}可接受的自定义参数`schema`。
     *
     * 基本同{@link IVideoTextureOptions}。
     */
    export interface IVideoTextureLoaderOptions {
        anisoLevel: number
        placeHolder?: string
        autoPlay?: boolean
        loop?: boolean
        abortAudio?: boolean
    }
    type IVideoTextureLoadData = IAssetLoadData<IVideoTextureLoaderOptions>
    /**
     * 视频纹理资源{@link VideoTexture}的加载器。
     */
    export default class VideoTextureLoader extends AssetLoader<
        VideoTexture,
        IVideoTextureLoaderOptions
    > {
        /**
         * 详见{@link IVideoTextureLoaderOptions}。
         */
        readonly schema: ILoaderOptionsSchema
        load(
            params: IVideoTextureLoadData,
            callbacks: {
                onLoading(progress: number): void
                onLoaded(value: VideoTexture): void
                onError(error: Error): void
            }
        ): Promise<void>
        release(params: IVideoTextureLoadData, value: VideoTexture): void
    }
    export {}
}

declare module 'XrFrame/loader/EnvDataLoader' {
    /**
     * EnvDataLoader.ts
     *
     *         * @Date    : 5/10/2022, 11:27:49 AM
     */
    import EnvData from 'XrFrame/assets/EnvData'
    import AssetLoader, {
        ILoaderOptionsSchema
    } from 'XrFrame/loader/AssetLoader'
    import { IAssetLoadData } from 'XrFrame/loader/types'
    interface IBufferSlice {
        offset: number
        length: number
        type: string
    }
    export interface IEnvDataSource {
        skybox?: {
            type: '2D' | 'Cube'
            half: boolean
            map: (string | string[]) | IBufferSlice
        }
        diffuse?: {
            coefficients: number[][]
        }
        specular?: {
            type: '2D'
            rgbd: boolean
            mipmaps: boolean
            mipmapCount?: number
            map: string | IBufferSlice
        }
    }
    export interface IEnvDataLoaderOptions {}
    type IEnvDataLoadData = IAssetLoadData<IEnvDataLoaderOptions>
    /**
     * 环境数据资源{@link EnvData}的加载器。
     *
     * 拥有内置资源`xr-frame-team-workspace-day`、`xr-frame-team-workspace-night`以及`xr-frame-team-workspace-day2`。
     * 加载的资源一般由[xr-frame-cli](https://github.com/wechat-miniprogram/xr-frame-cli)生成。
     */
    export default class EnvDataLoader extends AssetLoader<
        EnvData,
        IEnvDataLoaderOptions
    > {
        readonly schema: ILoaderOptionsSchema
        load(
            params: IEnvDataLoadData,
            callbacks: {
                onLoading(progress: number): void
                onLoaded(value: EnvData): void
                onError(error: Error): void
            }
        ): Promise<void>
        getBuiltin(): Array<{
            assetId: string
            src: string
            options: IEnvDataLoaderOptions
        }>
        release(params: IEnvDataLoadData, value: EnvData): void
    }
    export {}
}

declare module 'XrFrame/loader/GlTFLoader' {
    /**
     * GLTFLoader.ts
     *
     *         * @Date    : 2022/3/16下午3:47:56
     */
    import GLTFModel from 'XrFrame/assets/GLTFModel'
    import AssetLoader, {
        ILoaderOptionsSchema
    } from 'XrFrame/loader/AssetLoader'
    import { IAssetLoadData } from 'XrFrame/loader/types'
    import { Scene } from 'XrFrame/elements'
    export enum GLBChunkType {
        JSON = 1313821514,
        BIN = 5130562
    }
    export interface IGLTFLoaderOptions {
        ignoreTextureError?: boolean
    }
    type IGLTFLoadData = IAssetLoadData<IGLTFLoaderOptions>
    /**
     * GLTF资源加载器，加载完毕后返回一个{@link GLTFModel}。
     */
    export default class GLTFLoader extends AssetLoader<
        GLTFModel,
        IGLTFLoaderOptions
    > {
        readonly schema: ILoaderOptionsSchema
        load(
            params: IGLTFLoadData,
            callbacks: {
                onLoading(progress: number): void
                onLoaded(value: GLTFModel): void
                onError(error: Error): void
            }
        ): Promise<void>
        cancel(params: IGLTFLoadData): void
        release(params: IGLTFLoadData, value: GLTFModel): void
        /**
         * @internal
         */
        static createGLTFModel(
            scene: Scene,
            buffer: ArrayBuffer,
            src?: string,
            onLoading?: (progress: number) => void
        ): Promise<GLTFModel>
    }
    export {}
}

declare module 'XrFrame/loader/KeyframeLoader' {
    /**
     * KeyframeLoader.ts
     *
     *         * @Date    : 6/21/2022, 6:48:33 PM
     */
    import KeyframeAnimation from 'XrFrame/animation/KeyframeAnimation'
    import AssetLoader, {
        ILoaderOptionsSchema
    } from 'XrFrame/loader/AssetLoader'
    import { IAssetLoadData } from 'XrFrame/loader/types'
    export interface IKeyframeLoaderOptions {}
    type IKeyframeLoadData = IAssetLoadData<IKeyframeLoaderOptions>
    /**
     * 帧动画资源{@link KeyframeAnimation}的加载器。
     */
    export default class KeyframeLoader extends AssetLoader<
        KeyframeAnimation,
        IKeyframeLoaderOptions
    > {
        readonly schema: ILoaderOptionsSchema
        load(
            params: IKeyframeLoadData,
            callbacks: {
                onLoading(progress: number): void
                onLoaded(value: KeyframeAnimation): void
                onError(error: Error): void
            }
        ): Promise<void>
    }
    export {}
}

declare module 'XrFrame/loader/RawLoader' {
    import AssetLoader, {
        ILoaderOptionsSchema
    } from 'XrFrame/loader/AssetLoader'
    import { IAssetLoadData } from 'XrFrame/loader/types'
    /**
     * 原始数据加载器的参数。
     */
    export interface IRawLoaderOptions {
        /**
         * 编码，默认为`binary`。
         */
        encoding?: 'binary' | 'utf-8'
    }
    type IRawLoadData = IAssetLoadData<IRawLoaderOptions>
    /**
     * 原始数据的加载器。
     */
    export default class RawLoader extends AssetLoader<
        string | ArrayBuffer,
        IRawLoaderOptions
    > {
        readonly schema: ILoaderOptionsSchema
        load(
            params: IRawLoadData,
            callbacks: {
                onLoading(progress: number): void
                onLoaded(value: string | ArrayBuffer): void
                onError(error: Error): void
            }
        ): Promise<void>
    }
    export {}
}

declare module 'XrFrame/loader/AtlasLoader' {
    /**
     * AtlasLoader.ts
     *
     *         * @Date    : 10/13/2022, 5:35:00 PM
     */
    import Atlas from 'XrFrame/assets/Atlas'
    import AssetLoader, {
        ILoaderOptionsSchema
    } from 'XrFrame/loader/AssetLoader'
    import { IAssetLoadData } from 'XrFrame/loader/types'
    export interface IAtlasSource {
        meta: {
            image: string
            size: {
                w: number
                h: number
            }
        }
        frames: {
            [key: string]: {
                frame: {
                    x: number
                    y: number
                    w: number
                    h: number
                }
                spriteSourceSize: {
                    x: number
                    y: number
                    w: number
                    h: number
                }
                sourceSize: {
                    w: number
                    h: number
                }
            }
        }
    }
    export interface IAtlasLoaderOptions {}
    type IAtlasLoadData = IAssetLoadData<IAtlasLoaderOptions>
    /**
     * 图集资源{@link Atlas}的加载器。
     * @version 2.27.1
     *
     * 推荐使用[Shoebox](https://www.renderhjs.net/shoebox/)生成。
     */
    export default class AtlasLoader extends AssetLoader<
        Atlas,
        IAtlasLoaderOptions
    > {
        readonly schema: ILoaderOptionsSchema
        load(
            params: IAtlasLoadData,
            callbacks: {
                onLoading(progress: number): void
                onLoaded(value: Atlas): void
                onError(error: Error): void
            }
        ): Promise<void>
        getBuiltin(): Array<{
            assetId: string
            src: string
            options: IAtlasLoaderOptions
        }>
    }
    export {}
}

declare module 'XrFrame/loader/types' {
    /**
     * types.ts
     *
     *         * @Date    : 2022/4/1下午2:19:33
     */
    type Assets = import('XrFrame/components/Assets').default
    export function isAsset(value: any): value is IAssetWithState<any>
    export enum EAssetState {
        Undefined = 0,
        Defer = 1,
        Loading = 2,
        Existed = 3
    }
    export interface IAssetWithState<T> {
        __isAsset: boolean
        __params?: IAssetLoadData
        __group?: Assets
        value?: T
        state: EAssetState
        promise?: Promise<IAssetWithState<T>>
    }
    /**
     * {@link AssetLoad}组件数据接口。
     */
    export interface IAssetLoadData<T = any> {
        /**
         * 资源类型，必须是使用{@link registerAssetLoader}中注册过的类型。
         * `xml`中数据为`string`类型。
         */
        type: string
        /**
         * 资源Id。
         * `xml`中数据为`string`类型。
         */
        assetId: string
        /**
         * 资源地址。
         * `xml`中数据为`string`类型。
         */
        src: string
        /**
         * 资源权重，用于在同一批加载的资源的`progress`事件中计算进度，详见{@link Assets}。
         * `xml`中数据为`number`类型。
         */
        weight?: number
        /**
         * 资源追加配置，视资源类型而定。
         * `xml`中数据为`dict`类型。
         */
        options: T
        /**
         * 是否要按需延迟加载，如果开启，则只有在资源被实际引用时才会被加载。
         * `xml`中数据为`boolean`类型。
         */
        defer?: boolean
        /**
         * @internal
         */
        canceled?: boolean
        /**
         * @internal
         */
        startTs?: number
        /**
         * 加载时长(s)，仅用于统计。
         */
        duration?: number
        /**
         * 当前加载进度。
         */
        progress?: number
    }
    export {}
}

declare module 'XrFrame/animation/NativeAnimation' {
    import { Kanata } from 'XrFrame/ext'
    import Animation, { TDirection } from 'XrFrame/animation/Animation'
    import Element from 'XrFrame/core/Element'
    export enum ENativeAnimationSimulatorType {
        None = 0,
        Morph = 1
    }
    export interface INativeAnimationData {
        clip: Kanata.AnimationClipModel
        bindings: Kanata.Entity3D[]
        frameCount: number
        names: string[]
        simulators?: Array<{
            type: ENativeAnimationSimulatorType
            target: Element
            subElements: Element[]
        }>
    }
    export const DefaultNativeAnimationFPS = 60
    /**
     * 使用客户端加速的动画片段，通常由gltf实例化而来，仅供内部使用。
     */
    export default class NativeAnimation extends Animation<INativeAnimationData> {
        onInit(data: INativeAnimationData): void
        onPlay(
            el: Element,
            clipName: string,
            options: any
        ): {
            duration: number
            loop?: number
            delay?: number
            direction?: TDirection
        }
        onUpdate(el: Element, progress: number, reverse: boolean): void
    }
}

declare module 'XrFrame/loader/glTF/GLTFRootNode' {
    import {
        GLTFAnimationsLoaded,
        GLTFAnimationsNodeRaw
    } from 'XrFrame/loader/glTF/animations/GLTFAnimationsNode'
    import { GLTFAccessorsNodeRaw } from 'XrFrame/loader/glTF/buffers/GLTFAccessorsNode'
    import { GLTFBuffersNodeRaw } from 'XrFrame/loader/glTF/buffers/GLTFBuffersNode'
    import { GLTFBufferViewsNodeRaw } from 'XrFrame/loader/glTF/buffers/GLTFBufferViewsNode'
    import { GLTFExtensionsProfiles } from 'XrFrame/loader/glTF/extensions/GLTFExtensions'
    import {
        GLTFMeshesLoaded,
        GLTFMeshesNodeRaw
    } from 'XrFrame/loader/glTF/geometry/GLTFMeshesNode'
    import { GLTFBaseNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import {
        GLTFMaterialsLoaded,
        GLTFMaterialsNodeRaw
    } from 'XrFrame/loader/glTF/materials/GLTFMaterialsNode'
    import GLTFNodesNode, {
        GLTFNodesLoaded,
        GLTFNodesNodeRaw
    } from 'XrFrame/loader/glTF/scenes/GLTFNodesNode'
    import { GLTFSceneLoaded } from 'XrFrame/loader/glTF/scenes/GLTFSceneNode'
    import {
        GLTFScenesLoaded,
        GLTFScenesNodeRaw
    } from 'XrFrame/loader/glTF/scenes/GLTFScenesNode'
    import {
        GLTFSkinsLoaded,
        GLTFSkinsNodeRaw
    } from 'XrFrame/loader/glTF/skins/GLTFSkinsNode'
    import { GLTFImagesNodeRaw } from 'XrFrame/loader/glTF/textures/GLTFImagesNode'
    import {
        GLTFSamplersLoaded,
        GLTFSamplersNodeRaw
    } from 'XrFrame/loader/glTF/textures/GLTFSamplersNode'
    import {
        GLTFTexturesLoaded,
        GLTFTexturesNodeRaw
    } from 'XrFrame/loader/glTF/textures/GLTFTexturesNode'
    type Scene = import('XrFrame/core/Scene').default
    export interface GLTFRootNodeRaw {
        buffers?: GLTFBuffersNodeRaw
        bufferViews?: GLTFBufferViewsNodeRaw
        accessors?: GLTFAccessorsNodeRaw
        images?: GLTFImagesNodeRaw
        samplers?: GLTFSamplersNodeRaw
        textures?: GLTFTexturesNodeRaw
        materials?: GLTFMaterialsNodeRaw
        meshes?: GLTFMeshesNodeRaw
        nodes?: GLTFNodesNodeRaw
        scenes?: GLTFScenesNodeRaw
        skins?: GLTFSkinsNodeRaw
        animations?: GLTFAnimationsNodeRaw
        scene?: number
        extensions?: object
        extensionsRequired?: string[]
        extensionsUsed?: string[]
    }
    export interface GLTFRootLoaded {
        samplers: GLTFSamplersLoaded
        textures: GLTFTexturesLoaded
        materials: GLTFMaterialsLoaded
        meshes: GLTFMeshesLoaded
        nodes: GLTFNodesLoaded
        scenes: GLTFScenesLoaded
        scene: GLTFSceneLoaded
        skins: GLTFSkinsLoaded
        animations: GLTFAnimationsLoaded
    }
    export interface GLTFDesc {
        raw: object
        scene: Scene
        uri?: string
        extensionProfiles?: GLTFExtensionsProfiles
        defaultBinary?: ArrayBuffer
    }
    export default class GLTFRootNode extends GLTFBaseNode {
        get nodeName(): string
        readonly raw: GLTFRootNodeRaw
        readonly uri: string
        readonly defaultBinary: ArrayBuffer | null
        nodesNode: GLTFNodesNode | undefined
        constructor(desc: GLTFDesc)
        build(): void
        preload(
            reportProgress?: (progress: number) => void
        ): Promise<GLTFRootLoaded>
        getLoadedResource(): GLTFRootLoaded
        getNodesByPath(path: string): GLTFBaseNode[]
        getRootExtensionRaw(extName: string): object | undefined
        /**
         * 在preload完之后可以调用这个函数，会把原始buffer的引用都释放掉。
         * 每个子节点的raw也会释放掉（以防数据是dataURI的形式）。
         */
        releaseRawBuffer(): void
    }
    export {}
}

declare module 'XrFrame/loader/glTF/scenes/GLTFNodesNode' {
    import { GLTFArrayNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import GLTFNodeNode, {
        GLTFNodeLoaded,
        GLTFNodeNodeRaw,
        GLTFNodePrerequisites
    } from 'XrFrame/loader/glTF/scenes/GLTFNodeNode'
    type ChildNode = GLTFNodeNode
    export type GLTFNodesNodeRaw = GLTFNodesNodeRaw[]
    export type GLTFTreeNode = {
        data: GLTFNodeLoaded
        children: GLTFTreeNode[]
        parent: GLTFTreeNode | null
        index: number
        extension?: object
    }
    export type GLTFNodesLoaded = GLTFTreeNode[]
    export default class GLTFNodesNode extends GLTFArrayNode<ChildNode> {
        ChildCtor(childRaw: GLTFNodeNodeRaw): GLTFNodeNode
        readonly raw: GLTFNodesNodeRaw
        get nodeName(): string
        res: GLTFNodesLoaded
        preload(prerequisites: GLTFNodePrerequisites): Promise<GLTFNodesLoaded>
        getLoadedResource(): GLTFNodesLoaded
    }
    export {}
}

declare module 'XrFrame/kanata/lib/frontend' {
    import MeshRendererComponent from 'XrFrame/kanata/lib/frontend/component/MeshRendererComponent'
    import renderEnv from 'XrFrame/kanata/lib/frontend/resource/renderEnv'
    export { RenderEnv } from 'XrFrame/kanata/lib/frontend/resource/renderEnv'
    export { default as AnimatorComponent } from 'XrFrame/kanata/lib/frontend/component/AnimatorComponent'
    export { default as CameraComponent } from 'XrFrame/kanata/lib/frontend/component/CameraComponent'
    export { default as LightCameraComponent } from 'XrFrame/kanata/lib/frontend/component/LightCameraComponent'
    export { default as CullingComponent } from 'XrFrame/kanata/lib/frontend/component/CullingComponent'
    export { default as MeshRendererComponent } from 'XrFrame/kanata/lib/frontend/component/MeshRendererComponent'
    export { default as SkinnedSkeletonComponent } from 'XrFrame/kanata/lib/frontend/component/SkinnedSkeletonComponent'
    export { default as DynamicBonesComponent } from 'XrFrame/kanata/lib/frontend/component/DynamicBonesComponent'
    export { default as Entity2D } from 'XrFrame/kanata/lib/frontend/entity/Entity2D'
    export { default as Entity3D } from 'XrFrame/kanata/lib/frontend/entity/Entity3D'
    export { default as AnimationClipModel } from 'XrFrame/kanata/lib/frontend/resource/AnimationClipModel'
    export { default as AnimationClipBinding } from 'XrFrame/kanata/lib/frontend/resource/AnimationClipBinding'
    export { default as AnimatorControllerModel } from 'XrFrame/kanata/lib/frontend/resource/AnimatorControllerModel'
    export { default as AnimatorControllerStateModel } from 'XrFrame/kanata/lib/frontend/resource/AnimatorControllerStateModel'
    export { default as DataBuffer } from 'XrFrame/kanata/lib/frontend/resource/DataBuffer'
    export { default as DataModel } from 'XrFrame/kanata/lib/frontend/resource/DataModel'
    export { default as Effect } from 'XrFrame/kanata/lib/frontend/resource/Effect'
    export { default as Material } from 'XrFrame/kanata/lib/frontend/resource/Material'
    export {
        default as RenderPass,
        IRenderPassOptions
    } from 'XrFrame/kanata/lib/frontend/resource/RenderPass'
    export { default as SkeletonBoneInverseModel } from 'XrFrame/kanata/lib/frontend/resource/SkeletonBoneInverseModel'
    export {
        default as Texture,
        ITextureOptions
    } from 'XrFrame/kanata/lib/frontend/resource/Texture'
    export { default as UniformBlock } from 'XrFrame/kanata/lib/frontend/resource/UniformBlock'
    export { default as UniformDescriptor } from 'XrFrame/kanata/lib/frontend/resource/UniformDescriptor'
    export { default as IndexBuffer } from 'XrFrame/kanata/lib/frontend/resource/IndexBuffer'
    export { default as IndexData } from 'XrFrame/kanata/lib/frontend/resource/IndexData'
    export { default as VertexBuffer } from 'XrFrame/kanata/lib/frontend/resource/VertexBuffer'
    export { default as VertexData } from 'XrFrame/kanata/lib/frontend/resource/VertexData'
    export { default as VertexLayout } from 'XrFrame/kanata/lib/frontend/resource/VertexLayout'
    export { default as VertexDataDescriptor } from 'XrFrame/kanata/lib/frontend/resource/VertexDataDescriptor'
    export { default as View } from 'XrFrame/kanata/lib/frontend/resource/View'
    export { default as ScalableList } from 'XrFrame/kanata/lib/frontend/resource/ScalableList'
    export { default as crossContext } from 'XrFrame/kanata/lib/frontend/shared/crossContext'
    const IS_VALID: () => boolean,
        GET_MAIN_CANVAS: () => HTMLCanvasElement,
        Image: {
            new (): import('XrFrame/kanata/lib/backend').IImage
            IS(obj: any): obj is import('XrFrame/kanata/lib/backend').IImage
        },
        Phys3D: any
    const downloader: import('XrFrame/kanata/lib/backend').IDownloader
    export { renderEnv }
    export {
        Image,
        downloader as Downloader,
        IS_VALID,
        GET_MAIN_CANVAS,
        Phys3D
    }
    export const createWeakRef: <T>(wrapper: T) => {
        deref: () => T
    }
    export const createWeakRefSentry: () => any
    export const createNativeUUMap: () => import('XrFrame/kanata/lib/backend').INativeMap<number>
    export const createNativeSUMap: () => import('XrFrame/kanata/lib/backend').INativeMap<string>
    export const createNativeULUMap: () => import('XrFrame/kanata/lib/backend').ILongIntNativeMap
    export const loadTTFFont: (
        url: string,
        callback: (font: string) => void
    ) => void
    export const getGlyphInfo: (
        fontSetting: import('XrFrame/kanata/lib/backend').IFontSetting,
        charCode: number
    ) => import('XrFrame/kanata/lib/backend').IGlyphInfo
    export const refreshNodesWorldTransform: () => void
    export const setGlobalPhysicSystem: (system: any) => void
    export const bindRigidBodyToNode: (rigidBody: any, nodeId: number) => void
    export const bindCCTToNode: (cc: any, nodeId: number) => void
    export const unbindRigidBody: (rigidBody: any) => void
    export const unbindCCT: (cc: any) => void
    export const decodeBase64: (base64: string) => ArrayBuffer
    export function destroy(): void
    export function update(delta: number): void
    export const setNodeName: (id: number, name: string) => void
    export const setRenderComponentName: (
        comp: MeshRendererComponent,
        name: string
    ) => void
    export const debugPrint: (msg: string) => void
    export const eventBridge: {
        bindEntityToBone: any
        unbindEntityFromBone: any
        bindEntitiesToBones: any
        unbindEntitiesFromBones: any
    }
}

declare module 'XrFrame/kanata/lib/backend/interface' {
    /**
     * index.ts
     *
     *         * @Date    : 2020/8/18 下午4:48:36
     */
    export interface IEngineSettings {
        /** log过滤器 */
        logFilter: boolean
        /** log等级 */
        logLevel: string
        /** 最大缓存极限 */
        cacheSizeLimit: number
        /** 是否开启MSAA */
        realSizeLimit: number
        /** 设计分辨率宽 */
        designWidth: number
        /** 设计分辨率高 */
        designHeight: number
        /** 渲染分辨率宽 */
        renderWidth: number
        /** 渲染分辨率高 */
        renderHeight: number
        /** 是否开启MSAA */
        mainScreenMSAA: boolean
        /** loader下载文件的默认根路径 */
        baseURL: string
        /** 如果baseURL找不到并且重试次数`globalHTTPRetry`大于0，则会依次尝试使用 */
        backupURLs: string[]
        /** 全局loader下载文件重试次数 */
        globalHTTPRetry: string
        /** 物理引擎的重力 */
        gravity: number
        /** 物理引擎的模拟步进固定间隔 */
        fixedDeltaTime: number
        useEngineSubcontext: boolean
        /** 物理碰撞矩阵，以十六进制字符串表示 */
        physics3DLayerCollisionMatrix: string
        /** 拼缓存的文件名的 */
        cacheDelimiter: string
        /** 自动生成的worker文件入口路径 */
        workerPath: string
        /** worker执行任务超时时间 */
        workerTimeout: number
        gfxIgnoreAssert: boolean
        profileGfx: string
        /** 全局Uniform定义 */
        shaderGlobalProperties: Array<{
            key: string
            type:
                | 'Float'
                | 'Vector2'
                | 'Vector3'
                | 'Vector4'
                | 'Matrix4'
                | 'Texture'
            default: number | number[] | string
        }>
        /** 音频全局定义 */
        audio?: {
            /** 全局音量  */
            globalVolume?: number
            /** 真实音频数量上限 */
            maxRealVoices?: number
        }
    }
    /**
     * 顶点数据格式枚举。
     */
    export enum EVertexFormat {
        FLOAT = 0,
        FLOAT2 = 1,
        FLOAT3 = 2,
        FLOAT4 = 3,
        BYTE4 = 4,
        BYTE4N = 5,
        UBYTE4 = 6,
        UBYTE4N = 7,
        SHORT2 = 8,
        SHORT2N = 9,
        SHORT4 = 10,
        SHORT4N = 11,
        UINT10_N2 = 12
    }
    /**
     * 顶点数据步进类型枚举。
     */
    export enum EVertexStep {
        /**
         * 逐顶点。
         */
        PER_VERTEX = 0,
        /**
         * 在使用Instance的情况下，逐实例。
         */
        PER_INSTANCE = 1
    }
    /**
     * 索引数据类型。
     */
    export enum EIndexType {
        /**
         * 无效值。
         */
        NONE = 1,
        /**
         * 16位索引。
         */
        UINT16 = 2,
        /**
         * 32位索引，注意在某些设备上不支持。
         */
        UINT32 = 3
    }
    /**
     * 压缩纹理类型。
     */
    export type TCompressTexture = 'etc1' | 'etc2' | 'astc' | 'pvrtc' | 's3tc'
    /**
     * 纹理类型雷剧。
     */
    export enum ETextureType {
        /**
         * 2D纹理。
         */
        D2 = 0,
        /**
         * 立方体纹理。
         */
        Cube = 1,
        /**
         * 2D纹理数组。
         */
        D2Array = 2,
        /**
         * 3D纹理。
         */
        D3 = 3
    }
    /**
     * 纹理格式枚举。
     */
    export enum ETextureFormat {
        /** Inputs or Render Target Formats. */
        RGBA8 = 0,
        SRGBA8 = 1,
        RGB10A2 = 2,
        RG8 = 3,
        R8 = 4,
        RGBA32F = 5,
        RGBA16F = 6,
        RG11B10F = 7,
        /** Render Target Only. */
        Depth_Low = 20,
        Depth_High = 21,
        Depth_Stencil = 22,
        RGBA4 = 23,
        RGB565 = 24,
        RGB5A1 = 25,
        /** Compresseds */
        ETC1RGB8 = 100,
        ETC2RGB8 = 110,
        ETC2RGBA8 = 111,
        PVRTC2RGBV1 = 120,
        PVRTC4RGBV1 = 121,
        PVRTC2RGBAV1 = 122,
        PVRTC4RGBAV1 = 123,
        ASTC4x4 = 140,
        ASTC5x5 = 141,
        ASTC6x6 = 142,
        ASTC8x6 = 143,
        ASTC8x8 = 144,
        DXT1 = 150,
        DXT3 = 151,
        DXT5 = 152
    }
    /**
     * 纹理寻址模式枚举。
     */
    export enum EWrapMode {
        REPEAT = 1,
        CLAMP_TO_EDGE = 2,
        MIRRORED_REPEAT = 3
    }
    /**
     * 纹理过滤模式枚举。
     */
    export enum EFilterMode {
        NEAREST = 1,
        LINEAR = 2,
        NEAREST_MIPMAP_NEAREST = 3,
        NEAREST_MIPMAP_LINEAR = 4,
        LINEAR_MIPMAP_NEAREST = 5,
        LINEAR_MIPMAP_LINEAR = 6
    }
    /**
     * Uniform值得类型枚举。
     */
    export enum EUniformType {
        FLOAT = 0,
        FLOAT2 = 1,
        FLOAT3 = 2,
        FLOAT4 = 3,
        MAT2 = 4,
        MAT3 = 5,
        MAT4 = 6,
        SAMPLER = 7
    }
    /**
     * 背面剔除类型枚举。
     */
    export enum ECullMode {
        NONE = 0,
        FRONT = 1,
        BACK = 2
    }
    /**
     * 正面顶点绕序枚举。
     */
    export enum EFaceWinding {
        CCW = 1,
        CW = 2
    }
    /**
     * 各种测试的比较函数枚举。
     */
    export enum ECompareFunc {
        LESS = 1,
        LEQUAL = 2,
        EQUAL = 3,
        GEQUAL = 4,
        GREATER = 5,
        NOTEQUAL = 6,
        NEVER = 7,
        ALWAYS = 8
    }
    /**
     * 模板测试操作枚举。
     */
    export enum EStencilOp {
        ZERO = 0,
        KEEP = 1,
        REPLACE = 2,
        INCR_WRAP = 3,
        INCR = 4,
        DECR_WRAP = 5,
        DECR = 6,
        INVERT = 7
    }
    /**
     * 混合因子枚举。
     */
    export enum EBlendFactor {
        ZERO = 0,
        ONE = 1,
        SRC_COLOR = 2,
        ONE_MINUS_SRC_COLOR = 3,
        SRC_ALPHA = 4,
        ONE_MINUS_SRC_ALPHA = 5,
        DST_ALPHA = 6,
        ONE_MINUS_DST_ALPHA = 7,
        DST_COLOR = 8,
        ONE_MINUS_DST_COLOR = 9,
        SRC_ALPHA_SATURATE = 10,
        CONSTANT_COLOR = 11,
        ONE_MINUS_CONSTANT_COLOR = 12
    }
    /**
     * 混合方式枚举。
     */
    export enum EBlendEquation {
        FUNC_ADD = 0,
        FUNC_SUBTRACT = 1,
        FUNC_REVERSE_SUBTRACT = 2,
        MIN = 3,
        MAX = 4
    }
    /**
     * 颜色通道掩码枚举。
     */
    export enum EColorMask {
        /**
         * 将会禁掉所有通道的输出。
         */
        NONE = 16,
        R = 1,
        G = 2,
        B = 4,
        A = 8,
        RGB = 7,
        RGBA = 15
    }
    /**
     * 像素数据类型枚举。
     */
    export enum EPixelType {
        UNSIGNED_BYTE = 5121,
        FLOAT = 5126,
        UNSIGNED_SHORT_5_6_5 = 33635,
        UNSIGNED_SHORT_4_4_4_4 = 32819,
        UNSIGNED_SHORT_5_5_5_1 = 32820
    }
    /**
     * 清屏操作枚举。
     */
    export enum ELoadAction {
        /**
         * 清除屏幕颜色。
         */
        CLEAR = 0,
        /**
         * 不清屏，但依赖前面渲染的结果。
         */
        LOAD = 1,
        /**
         * 完全不关心是否清屏。
         */
        DONTCARE = 2
    }
    export enum EDataModelType {
        AnimationClip = 1,
        SkeletonBoneInverse = 2
    }
    /**
     * 渲染组件类型枚举。
     */
    export enum EMeshRenderType {
        /**
         * 未知类型。
         */
        UnKnown = 0,
        /**
         * 静态3D类型。
         */
        Static3D = 1,
        /**
         * 蒙皮3D类型。
         */
        Skinned3D = 2,
        /**
         * UI类型。
         */
        UI = 3
    }
    /**
     * 图元渲染类型枚举。
     */
    export enum EPrimitiveType {
        TRIANGLES = 0,
        TRIANGLE_STRIP = 1,
        LINES = 2,
        LINE_STRIP = 3,
        POINTS = 4,
        ZERO = 5
    }
    /**
     * 阴影类型枚举。
     */
    export enum EShadowMode {
        /**
         * 关闭阴影。
         */
        None = 0,
        /**
         * 开启单级联阴影，并开启PCF。
         */
        OneCascade_PCF = 1,
        /**
         * 开启二级联阴影，并开启PCF。
         */
        TwoCascade_PCF = 2,
        /**
         * 开启四级联阴影，并开启PCF。
         */
        FourCascade_PCF = 4,
        /**
         * 开启单级联阴影，并开启PCSS。
         */
        PCSS = 5
    }
    /**
     * 阴影匹配类型枚举。
     */
    export enum EShadowFitMode {
        /**
         * 阴影范围适配视锥体。
         * 更稳定，可能降低阴影精度。
         */
        FitFrustum = 0,
        /**
         * 阴影范围适配物体。
         * 能提高阴影精度，但可能会导致阴影不稳定。
         */
        FitObjects = 1
    }
    /**
     * 顶点数据布局用途枚举。
     */
    export enum EVertexLayoutUsage {
        CUSTOM = 0,
        POSITION = 1,
        NORMAL = 2,
        TANGENT = 3,
        UV0 = 4,
        UV1 = 5,
        UV2 = 6,
        UV3 = 7,
        COLOR = 8,
        BONEINDEX = 9,
        BONEWEIGHT = 10
    }
    /**
     * 动态合批操作符枚举。
     */
    export enum EVertexBatchOperator {
        /**
         * 矩阵乘法。
         */
        MatrixMultiple = 0,
        /**
         * Scale offset。
         */
        UVST = 1
    }
    export enum EAnimationBlendType {
        Override = 0,
        Additive = 1
    }
    export enum EUseDefaultAddedAction {
        Ignore = 0,
        Refresh = 1
    }
    export enum EUseDefaultRetainedAction {
        Keep = 0,
        Refresh = 1,
        WriteBack = 2
    }
    export enum EUseDefaultRemovedAction {
        Keep = 0,
        Clear = 1,
        WriteBack = 2
    }
    export enum ESkinnedSkeletonFlag {
        Use3x4Matrix = 1,
        UseTextureMatrix = 2
    }
    export const RENDER_ENV_OFFSETS: {
        size: number
        resetFlag: number
        renderPass: number
        canvasWidth: number
        canvasHeight: number
        uniforms: number
        useInstanceOrNeverTranspose: number
    }
    export const POOL_SUB_ID_MASK = 65472
    export const POOL_SUB_ID_SHIT = 6
    export const ENTITY2D_OFFSETS: {
        size: number
        rotation: number
        position: number
        scale: number
        worldMatrix: number
    }
    export const ENTITY3D_OFFSETS: {
        size: number
        dfRotationType: number
        rotationType: number
        rotation: number
        position: number
        scale: number
        worldOffset: number
        worldMatrix: number
    }
    export const ENTITY3D_EXT_OFFSETS: {
        size: number
        layer: number
        mixedLayerMask: number
    }
    export const CULLING_OFFSETS: {
        size: number
        active: number
        dfActive: number
        layer: number
        boundingBallCenter: number
        boundingBallRadius: number
        entityId: number
    }
    export const CAMERA_OFFSETS: {
        size: number
        view: number
        depth: number
        active: number
        fov: number
        aspect: number
        near: number
        far: number
        up: number
        eye: number
        orthoSize: number
        isProjection: number
        cullingMask: number
        canvasSizeY: number
        targetTransform: number
        viewMatrix: number
        projectionMatrix: number
        viewMatrixInverse: number
        viewMatrix2D: number
        projectionMatrix2D: number
        viewMatrixInverse2D: number
        manualMatrix: number
        layerCullDistances: number
    }
    export const LIGHT_OFFSETS: {
        size: number
        view: number
        depth: number
        active: number
        shadowDistance: number
        shadowMode: number
        shadowFilterMode: number
        lightDir: number
        bounds: number
        lightSpaceMatrices: number
    }
    export const MESH_OFFSETS: {
        dynamicBatch: number
        skinHandle: number
        castShadow: number
        bindTarget: number
        start: number
        size: number
        materialId: number
        vertexBufferId: number
        indexBufferId: number
        startIndex: number
        numIndices: number
    }
    export const EFFECT_OFFSETS: {
        size: number
        useMaterialStates: number
        fstencil: number
        bstencil: number
        blendRGBA: number
        colorDepth: number
        state: number
    }
    export const MATERIAL_OFFSETS: {
        size: number
        renderQueue: number
        effect: number
        uniformBlock: number
        fstencilMask: number
        bstencilMask: number
        blendRGBAMask: number
        colorDepthMask: number
        stateMask: number
        fstencil: number
        bstencil: number
        blendRGBA: number
        colorDepth: number
        state: number
        useInstance: number
    }
    export const SKINNED_SKELETON_OFFSETS: {
        boneInverseModelId: number
        boneIndices: number
        perBoneIndices: number
        perBoneEntityId: number
        perBoneMatrixOld: number
        perBoneMatrixNew: number
    }
    export const DYNAMIC_BONES_OFFSETS: {
        stiffness: number
        elasticity: number
        damping: number
    }
    export interface IHandle {
        id: number
        data?: ArrayBuffer
        destroy?: Function
        __feObj?: any
    }
    /**
     * 顶点布局解构初始化参数。
     */
    export interface IVertexLayoutOptions {
        /**
         * 顶点属性列表。
         */
        attributes: Array<{
            /**
             * 属性名字。
             */
            name: string
            /**
             * 属性名格式。
             */
            format: EVertexFormat
            /**
             * 属性在Buffer中的偏移量（字节）。
             */
            offset: number
            /**
             * 属性的用途。
             */
            usage: EVertexLayoutUsage
        }>
        /**
         * 步进类型。
         *
         * @default EVertexStep.PER_VERTEX
         */
        step?: EVertexStep
        /**
         * 步长，不设定会自动计算。
         */
        stride?: number
        /**
         * 步进单位。
         *
         * @default 1
         */
        stepRate?: number
    }
    /**
     * 动态合批描述符创建参数。
     */
    export interface IVertexDataDescriptorOptions {
        vuMap: Array<[string, string, EVertexBatchOperator?]>
        ignored?: string[]
        ubIndex?: number
    }
    /**
     * UniformBlock描述符创建参数。
     */
    export interface IUniformDescriptorOptions {
        /**
         * 名字。
         */
        name?: string
        /**
         * Uniform描述列表。
         */
        uniforms: Array<{
            /**
             * 名字。
             */
            name: string
            /**
             * 类型。
             */
            type: EUniformType
            /**
             * 长度。
             */
            num?: number
            /**
             * @deprecated
             */
            needTranspose?: boolean
        }>
    }
    /**
     * 引擎原生图片接口。
     */
    export interface IImage {
        /**
         * 是否要预乘Alpha。
         */
        premultiplyAlpha: boolean
        /**
         * 加载完成的回调。
         */
        onload: (() => void) | null
        /**
         * 出错的回调。
         */
        onerror: ((error: Error) => void) | null
        /**
         * @internal
         */
        buffer?: ArrayBuffer
        /**
         * 对于`ArrayBuffer`创建的图片，第一次使用后是否要自动释放内存，在`xr-frame`中，默认自动释放。
         */
        autoRelease?: boolean
        /**
         * 图片地址或者待解码的ArrayBuffer。
         */
        src: string | ArrayBuffer | ArrayBufferView
        /**
         * 图片源于ArrayBuffer时，传入的mimetype。
         */
        type?: string
        /**
         * 图片本地缓存地址，仅在微信内有用。
         */
        localPath?: string
        /**
         * 图片宽度。
         */
        width: number
        /**
         * 图片高度。
         */
        height: number
        /**
         * 解码数据，视不同Backend而定。
         */
        readonly data?: ArrayBuffer | HTMLImageElement
    }
    /**
     * 可用于纹理的资源。
     */
    export type TTextureSource = ArrayBuffer | ArrayBufferView | IImage
    /**
     * 外部需要注入的下载器接口。
     */
    export interface IRealDownloader {
        load: (options: {
            src: string
            encoding: 'binary' | 'utf-8' | undefined
            onLoad: (res: { data: ArrayBuffer, filePath: string }) => void
            onError: (error: Error) => void
        }) => void
    }
    /**
     * 下载器。
     */
    export interface IDownloader {
        inWX: boolean
        REAL_DOWNLOADER: IRealDownloader
        LOAD(options: Parameters<IRealDownloader['load']>[0]): void
    }
    /**
     * 字体配置。
     */
    export interface IFontSetting {
        fontFamily: string
        bold?: string
        italic?: string
        size?: number
    }
    /**
     * 渲染层提供的特性列表。
     */
    export interface IFeatures {
        /**
         * 是否支持GPU实例化。
         */
        gpuInstance: boolean
        /**
         * 是否支持3D动态合批。
         */
        dynamicBatch3D: boolean
        /**
         * 是否支持硬件SRGB解码。
         */
        srgb: boolean
        /**
         * 是否支持各向异性滤波。
         */
        textureAnisotropic: boolean
        /**
         * 是否支持浮点纹理。
         */
        textureFloat: boolean
        /**
         * 是否支持半精度浮点纹理。
         */
        textureHalfFloat: boolean
        /**
         * 是否支持浮点类型的颜色缓冲。
         */
        colorBufferFloat: boolean
        /**
         * 是否支持深度纹理。
         */
        depthTexture: boolean
        /**
         * 是否支持在片段着色器采样深度。
         */
        fragDepth: boolean
    }
    export interface IRect {
        x: number
        y: number
        w: number
        h: number
    }
    /**
     * 对一个View进行清屏的操作。
     */
    export interface IViewAction {
        /**
         * 颜色操作。
         */
        colorAction?: ELoadAction
        /**
         * 深度操作。
         */
        depthAction?: ELoadAction
        /**
         * 模板操作。
         */
        stencilAction?: ELoadAction
        /**
         * 用于清屏的颜色值。
         *
         * @default [0,0,0,0]
         */
        clearColor?: [number, number, number, number]
        /**
         * 用于清屏的深度值。
         *
         * @default 1
         */
        clearDepth?: number
        /**
         * 用于清屏的模板值。
         *
         * @default 0
         */
        clearStencil?: number
    }
    /**
     * 视图接口。
     */
    export interface IView {
        /**
         * 视图清屏操作。
         */
        passAction: IViewAction
        /**
         * 视图区域。
         */
        viewport: IRect
        /**
         * 裁剪区域。
         */
        scissor: IRect
    }
    /**
     * 附件接口。
     */
    export interface IAttachment {
        texture: IHandle
        level?: number
        slice?: number
    }
    /**
     * 渲染通道描述符。
     */
    export interface IRenderPassDescriptor {
        colors: IAttachment[]
        depth: IAttachment
        stencil: IAttachment
    }
    export enum EEventType {
        SetRootEntity = 1,
        AddChild = 2,
        AddChildAtIndex = 3,
        RemoveFromParent = 4,
        DisperseSubTree = 5,
        BindToBone = 6,
        BindToBones = 7,
        UnBindFromBone = 8,
        UnBindFromBones = 9,
        EntityCommandActive = 10,
        EntityCommandInActive = 11
    }
    export interface IGlyphInfo {
        code: number
        tex: number
        uv_x: number
        uv_y: number
        uv_w: number
        uv_h: number
        advance: number
        bearing_x: number
        bearing_y: number
        width: number
        height: number
    }
    export interface IEventBridge {
        entityAddChild(entity: number, child: number): void
        entityAddChildAtIndex(
            entity: number,
            child: number,
            index: number
        ): void
        entityRemoveFromParent(entity: number): void
        entityClear(entity: number): void
        entitySetActive(entity: number, active: boolean): void
        entitySetLocalMatrixDirty(entity: number): void
        setRootEntity(entity: number): void
        refreshWorldTransform(): void
        bindEntityToBone(
            entity: {
                id: number
            },
            boneEntity: {
                id: number
            }
        ): void
        unbindEntityFromBone(entity: { id: number }): void
        bindEntitiesToBones(
            entities: Array<{
                id: number
            }>,
            boneEntities: Array<{
                id: number
            }>
        ): void
        unbindEntitiesFromBones(
            entities: Array<{
                id: number
            }>
        ): void
    }
    export interface IRenderEnv extends IHandle {
        version?: string
        backendType: string
        registerFallbackEffect(lightMode: string, handle?: IHandle): void
        changeMacros(macros: {
            [name: string]: string | number | boolean
        }): void
        changeVirtualMacros(macros: { [name: string]: boolean }): void
        setInternalInstanceInfo(
            type: EMeshRenderType,
            info: Array<{
                uniformKey: string
                attributeName: string
                type: EUniformType
            }>,
            ignored: string[]
        ): void
        getErrors(): string[]
        supportCompressTextures: TCompressTexture[]
        features: IFeatures
        commit_version: string
        use_puppet_sokol: boolean
    }
    export interface INativeMap<T> {
        set(key: T, value: number): void
        get(key: T): number | undefined
        del(key: T): void
    }
    export interface ILongIntNativeMap {
        set(key1: number, key2: number, value: number): void
        get(key1: number, key2: number): number | undefined
        del(key1: number, key2: number): void
    }
    export type WeakRef = any
}

declare module 'XrFrame/kanata/lib/index' {
    /**
     * index.ts
     *
     *         * @Date    : 2020/8/18 下午4:48:36
     */
    export * from 'XrFrame/kanata/lib/frontend'
    export * from 'XrFrame/kanata/lib/backend/interface'
    export const VERSION = '1.0.4'
    const Puppet: any
    export { Puppet }
    /**
     * 根据数据，返回二维节点对应结构的Float32array
     */
    export function composeRawBufferEntity2D(
        rotation: number,
        position: ArrayLike<number>,
        scale: ArrayLike<number>
    ): Float32Array
    /**
     * 根据数据，返回三维节点对应结构的Float32array，除WorldMatrix。
     */
    export function composeRawBufferEntity3D(
        useEuler: boolean,
        rotation: ArrayLike<number>,
        position: ArrayLike<number>,
        scale: ArrayLike<number>
    ): Float32Array
    /**
     * 根据数据，返回三维节点对应结构的Float32array
     */
    export function composeRawBufferEntity3DWhole(
        useEuler: boolean,
        rotation: ArrayLike<number>,
        position: ArrayLike<number>,
        scale: ArrayLike<number>
    ): Float32Array
}

declare module 'XrFrame/glyph' {
    export interface IGlyph {
        character?: string
        offsetX: number
        offsetY: number
        bearingX: number
        bearingY: number
        advance: number
        width: number
        height: number
        uvs: number[]
        texture: number
    }
}

declare module 'XrFrame/components/particle/ParticleInstance' {
    import {
        FactorGradient,
        ColorGradient
    } from 'XrFrame/components/particle/gradient'
    import Particle from 'XrFrame/components/particle/Particle'
    import Vector2 from 'XrFrame/math/vector2'
    import Vector3 from 'XrFrame/math/vector3'
    import Vector4 from 'XrFrame/math/vector4'
    export default class ParticleInstance {
        static count: number
        id: number
        position: Vector3
        direction: Vector3
        speed: number
        color: Vector4
        colorStep: Vector4
        rampPos: Vector4
        lifeTime: number
        age: number
        drag: number
        size: number
        startSize: number
        sizeGradientFactor: number
        scale: Vector2
        angle: number
        angularSpeed: number
        particleSystem: Particle
        currentSize: number
        currentSize2: number
        currentSizeGradient: FactorGradient
        currentColor: Vector4
        currentColor2: Vector4
        currentColorGradient: ColorGradient
        currentAlpha: number
        currentAlpha2: number
        currentAlphaGradient: FactorGradient
        currentSpeedScale: number
        currentSpeedScale2: number
        currentSpeedScaleGradient: FactorGradient
        currentLimitSpeed: number
        currentLimitSpeed2: number
        currentLimitSpeedGradient: FactorGradient
        currentDrag: number
        currentDrag2: number
        currentDragGradient: FactorGradient
        subEmitterMuster: any
        startSpriteCellIndex: number
        endSpriteCellIndex: number
        cellIndex: number
        randomCellOffset: any
        constructor(particle: Particle)
        /**
         * 重置粒子实例的状态。
         */
        reset(): void
        /**
         * 将当前粒子实例的状态拷贝到目标实例。
         * @param {ParticleInstance} other 目标粒子实例
         */
        copyTo(other: ParticleInstance): void
        /**
         * 更新从动画图集采样的帧序号
         */
        updateCellIndex(): void
        clamp(num: any, left?: number, right?: number): any
    }
}

declare module 'XrFrame/components/emitter/BasicShapeEmitter' {
    import Vector3 from 'XrFrame/math/vector3'
    import ParticleInstance from 'XrFrame/components/particle/ParticleInstance'
    import Matrix4 from 'XrFrame/math/matrix4'
    export abstract class BasicShapeEmitter {
        /**
         * keep normalized length
         */
        direction?: Vector3
        /**
         * keep normalized length
         */
        direction2?: Vector3
        abstract startDirection(
            worldMatrix: Matrix4,
            direction: Vector3,
            ...args: any[]
        ): void
        abstract startPosition(
            worldMatrix: Matrix4,
            position: Vector3,
            ...args: any[]
        ): void
        processInstance?(instance: ParticleInstance, deltaTime: number): void
        setProperty(properties: any): void
    }
}

declare module 'XrFrame/components/emitter' {
    import BoxShapeEmitter from 'XrFrame/components/emitter/BoxShapeEmitter'
    import PointShapeEmitter from 'XrFrame/components/emitter/PointShapeEmitter'
    import DrawShapeEmitter from 'XrFrame/components/emitter/DrawShapeEmitter'
    import SphereShapeEmitter from 'XrFrame/components/emitter/SphereShapeEmitter'
    import ConeShapeEmitter from 'XrFrame/components/emitter/ConeShapeEmitter'
    import CircleShapeEmitter from 'XrFrame/components/emitter/CircleShapeEmitter'
    export {
        BoxShapeEmitter,
        PointShapeEmitter,
        DrawShapeEmitter,
        SphereShapeEmitter,
        ConeShapeEmitter,
        CircleShapeEmitter
    }
}

declare module 'XrFrame/components/emitter/SubEmitter' {
    import Particle from 'XrFrame/components/particle/Particle'
    /**
     * 粒子子发射器的依附状态。
     */
    export const enum SubEmitterState {
        /**
         * 依附于粒子整个生命周期
         */
        ATTACH = 0,
        /**
         * 在粒子生命周期末出现
         */
        END = 1
    }
    export class SubEmitter {
        particleSystem: Particle
        state: SubEmitterState
        constructor(particleSystem: any)
        /**
         * 通过克隆，获取指定的粒子子发射器实例
         * @return {SubEmitter} 克隆后的子发射器实例
         */
        clone(): SubEmitter
    }
}

declare module 'XrFrame/components/physics/Rigidbody' {
    export default class Rigidbody {
        nativeComp: phys3D.Rigidbody
    }
}

declare module 'XrFrame/components/gizmo/CapsuleGizmo' {
    import Component from 'XrFrame/core/Component'
    import Element from 'XrFrame/core/Element'
    export interface ICapsuleGizmoData {
        radius: number
        height: number
        direction: number
        center: [number, number, number]
    }
    export const CapsuleGizmoSchema: {}
    export default class CapsuleGizmo extends Component<ICapsuleGizmoData> {
        static pieces: number
        onAdd(parent: Element, data: ICapsuleGizmoData): void
        onUpdate(data: ICapsuleGizmoData, preData: ICapsuleGizmoData): void
        onTick(deltaTime: number, data: ICapsuleGizmoData): void
        onRemove(parent: Element, data: ICapsuleGizmoData): void
        onRelease(data: ICapsuleGizmoData): void
    }
}

declare module 'XrFrame/components/gizmo/CubeGizmo' {
    import Component from 'XrFrame/core/Component'
    import Element from 'XrFrame/core/Element'
    export interface ICubeGizmoData {
        size: [number, number, number]
        center: [number, number, number]
    }
    export const CubeGizmoSchema: {}
    export default class CubeGizmo extends Component<ICubeGizmoData> {
        onAdd(parent: Element, data: ICubeGizmoData): void
        onUpdate(data: ICubeGizmoData, preData: ICubeGizmoData): void
        onTick(deltaTime: number, data: ICubeGizmoData): void
        onRemove(parent: Element, data: ICubeGizmoData): void
        onRelease(data: ICubeGizmoData): void
    }
}

declare module 'XrFrame/render-graph/RenderGraph' {
    import RGNode, { TRGNodeAny } from 'XrFrame/render-graph/RGNode'
    import Camera from 'XrFrame/components/Camera'
    type RenderSystem = import('XrFrame/systems/RenderSystem').default
    type Scene = import('XrFrame/core/Scene').default
    interface IDigraphNode {
        node: TRGNodeAny
        ins: number
        dist: number[]
    }
    /**
     * 渲染图。
     *
     * @category Render
     */
    export default class RenderGraph<IOptions = any> {
        protected _name: string
        protected _options: IOptions
        protected _scene?: Scene
        protected _isActive: boolean
        protected _isDirty: boolean
        protected _unusedIds: number[]
        protected _digraph: Array<IDigraphNode | undefined>
        protected _sorted: TRGNodeAny[]
        /**
         * 图名字。
         */
        get name(): string
        /**
         * 当前正在运行的Game实例。
         */
        get scene(): import('XrFrame/core/Scene').default
        /**
         * 当前的渲染上下文。
         */
        get context(): import('XrFrame/systems/RenderSystem').default
        constructor(_name: string, _options: IOptions)
        /**
         * 创建一个节点。
         */
        createNode<TRGNode extends TRGNodeAny>(
            name: string,
            clz: new (...args: any) => TRGNode,
            options: TRGNode['options']
        ): TRGNode
        /**
         * 销毁一个节点。
         */
        destroyNode(rgNode: TRGNodeAny): void
        /**
         * 连接两个节点。
         *
         * @param inputKey 需要将`from`节点的输出连接到哪个`to`节点的输入。
         */
        connect<TToNode extends TRGNodeAny>(
            from: TRGNodeAny,
            to: TToNode,
            inputKey?: keyof TToNode['inputTypes']
        ): void
        /**
         * 断开两个节点的连接。
         */
        disconnect(from: TRGNodeAny, to: TRGNodeAny): void
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * 清空整个图，一般用于图的重新构建。
         *
         * @param filter 过滤出需要保留、不被销毁的缓存节点，这些节点只会被重置状态。
         */
        protected _clear(
            filter?: (node: RGNode<any, any, any>) => boolean
        ): void
        protected _handleCamerasChange: (context: RenderSystem) => void
        /**
         * 图在被第一次真正使用时的回调。
         */
        onActive(context: RenderSystem, options: IOptions): void
        /**
         * 在渲染上下文中的相机改变时调用，一般用于重新构建图。
         */
        onCamerasChange(cameras: Camera[], changeCameras: Camera[]): void
        /**
         * 在图每帧执行前调用。
         */
        onExecuteBegin(context: RenderSystem, options: IOptions): void
        /**
         * 在图每帧执行后调用。
         */
        onExecuteDone(context: RenderSystem, options: IOptions): void
        /**
         * 在图不再使用时调用。
         */
        onDisable(context: RenderSystem, options: IOptions): void
        /**
         * @internal
         *
         * 编译整张图。
         */
        showDebugInfo(
            callback?: (
                digraph: Array<IDigraphNode | undefined>,
                sorted: TRGNodeAny[]
            ) => void
        ): string
    }
    export {}
}

declare module 'XrFrame/systems/LightManager' {
    /**
     * LightManager.ts
     *
     *       * @Date    : 4/11/2022, 2:29:36 PM
     */
    import Camera from 'XrFrame/components/Camera'
    import Light from 'XrFrame/components/Light'
    export interface IMainLightsInfo {
        hasAmbient: boolean
        hasMainDir: boolean
        ambientColorIns: Float32Array
        mainDir: Float32Array
        mainColorIns: Float32Array
    }
    export interface IAddLightsInfo {
        count: number
        info: Float32Array
        dir: Float32Array
        pos: Float32Array
        colorIns: Float32Array
    }
    export default class LightManager {}
}

declare module 'XrFrame/physics/raycast' {
    import Vector3 from 'XrFrame/math/vector3'
    import RaycastHit from 'XrFrame/physics/RaycastHit'
    /**
     * raycast函数的参数。
     * @field origin 射线起点。
     * @field unitDir 射线方向（单位向量）。
     * @field distance 射线的最大长度。
     * @field hit 用来接收碰撞信息的容器。
     * @field layerMask 可以用来屏蔽一些碰撞体。
     * @field （未实现）queryTriggerInteraction，是否能与Trigger相交（默认能）。
     */
    export type RaycastDesc = {
        origin: Vector3
        unitDir: Vector3
        distance?: number
        hit?: RaycastHit
        layerMask?: number
    }
    /**
     * 射线检测，判断给定射线是否与至少一个碰撞体相交，并返回与**最近**的那个碰撞体相交的信息。
     */
    export function raycast(
        Phys3D: typeof phys3D,
        system: phys3D.PhysSystem,
        desc: RaycastDesc
    ): boolean
}

declare module 'XrFrame/loader/glTF/animations/GLTFAnimationsNode' {
    import { GLTFArrayNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import { GLTFNodesLoaded } from 'XrFrame/loader/glTF/scenes/GLTFNodesNode'
    import GLTFAnimationNode, {
        GLTFAnimationLoaded,
        GLTFAnimationNodeRaw
    } from 'XrFrame/loader/glTF/animations/GLTFAnimationNode'
    import { GLTFAccessorsLoaded } from 'XrFrame/loader/glTF/buffers/GLTFAccessorsNode'
    type ChildNode = GLTFAnimationNode
    export type GLTFAnimationsNodeRaw = GLTFAnimationsNodeRaw[]
    export type GLTFAnimationsLoaded = GLTFAnimationLoaded[]
    export default class GLTFAnimationsNode extends GLTFArrayNode<ChildNode> {
        ChildCtor(childRaw: GLTFAnimationNodeRaw): GLTFAnimationNode
        readonly raw: GLTFAnimationsNodeRaw
        get nodeName(): string
        preload: (
            prerequisites: [
                accessors: GLTFAccessorsLoaded,
                nodes: GLTFNodesLoaded
            ]
        ) => Promise<GLTFAnimationsLoaded>
        getLoadedResource(): GLTFAnimationsLoaded
    }
    export {}
}

declare module 'XrFrame/loader/glTF/buffers/GLTFAccessorsNode' {
    import { GLTFArrayNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import GLTFAccessorNode, {
        GLTFAccessorLoaded,
        GLTFAccessorNodeRaw
    } from 'XrFrame/loader/glTF/buffers/GLTFAccessorNode'
    import { GLTFBufferViewsLoaded } from 'XrFrame/loader/glTF/buffers/GLTFBufferViewsNode'
    type ChildNode = GLTFAccessorNode
    export type GLTFAccessorsNodeRaw = GLTFAccessorsNodeRaw[]
    export type GLTFAccessorsLoaded = GLTFAccessorLoaded[]
    export default class GLTFAccessorsNode extends GLTFArrayNode<ChildNode> {
        ChildCtor(childRaw: GLTFAccessorNodeRaw): GLTFAccessorNode
        readonly raw: GLTFAccessorsNodeRaw
        get nodeName(): string
        preload: (
            prerequisites: GLTFBufferViewsLoaded
        ) => Promise<GLTFAccessorsLoaded>
        getLoadedResource(): GLTFAccessorsLoaded
    }
    export {}
}

declare module 'XrFrame/loader/glTF/buffers/GLTFBuffersNode' {
    import { GLTFArrayNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import GLTFBufferNode, {
        GLTFBufferNodeRaw
    } from 'XrFrame/loader/glTF/buffers/GLTFBufferNode'
    type ChildNode = GLTFBufferNode
    export type GLTFBuffersNodeRaw = GLTFBufferNodeRaw[]
    export type GLTFBuffersLoaded = ArrayBuffer[]
    export default class GLTFBuffersNode extends GLTFArrayNode<ChildNode> {
        ChildCtor(childRaw: GLTFBufferNodeRaw): GLTFBufferNode
        readonly raw: GLTFBuffersNodeRaw
        get nodeName(): string
        getLoadedResource(): GLTFBuffersLoaded
    }
    export {}
}

declare module 'XrFrame/loader/glTF/buffers/GLTFBufferViewsNode' {
    import { GLTFArrayNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import { GLTFBufferLoaded } from 'XrFrame/loader/glTF/buffers/GLTFBufferNode'
    import GLTFBufferViewNode, {
        GLTFBufferViewLoaded,
        GLTFBufferViewNodeRaw
    } from 'XrFrame/loader/glTF/buffers/GLTFBufferViewNode'
    type ChildNode = GLTFBufferViewNode
    export type GLTFBufferViewsNodeRaw = GLTFBufferViewsNodeRaw[]
    export type GLTFBufferViewsLoaded = GLTFBufferViewLoaded[]
    export default class GLTFBufferViewsNode extends GLTFArrayNode<ChildNode> {
        ChildCtor(childRaw: GLTFBufferViewNodeRaw): GLTFBufferViewNode
        readonly raw: GLTFBufferViewsNodeRaw
        get nodeName(): string
        preload: (
            prerequisites: [GLTFBufferLoaded]
        ) => Promise<GLTFBufferViewsLoaded>
        getLoadedResource(): GLTFBufferViewsLoaded
    }
    export {}
}

declare module 'XrFrame/loader/glTF/extensions/GLTFExtensions' {
    /**
     * 创建GLTFExtensionProfileBuilder实例来定义一种extension，
     * 类内提供了三种方法来操作gltf树：
     * + 一种是substitutePreload，替换gltf节点的preload函数；
     * + 一种是postBuild，在gltf树preload全部完成之后，再对其进行自定义操作；
     * + 一种是registerRunInSlot，需要先在gltf节点内部使用extensionSlot定义一个槽位，然后往这个槽位里填写代码。
     *
     * 具体要使用哪些extension请看GLTFLoader.ts。
     */
    type SlotCode = (
        raw: object,
        extensionGlobal: object,
        prerequisites: any,
        args: any
    ) => Promise<void>
    type ForceSlotCode = (
        extensionGlobal: object,
        prerequisites: any,
        args: any
    ) => Promise<void>
    export class GLTFExtensionProfileBuilder {
        constructor(extName: string)
        registerRootInit(
            init: (raw: object, extensionGlobal: object) => void
        ): void
        registerSubstitutePreload(
            path: string,
            preload: (
                raw: object,
                extensionGlobal: object,
                prerequisites?: object
            ) => Promise<any>
        ): void
        registerPostBuild(
            execute: (root: any, extensionGlobal: object) => Promise<void>
        ): void
        registerRunInSlot(slotId: string, code: SlotCode): void
        /**
         * 不管当前节点有没有extension，都运行，但是运行的时候不会给extRaw（因为可能没有）。
         */
        registerForceRunInSlot(slotId: string, code: ForceSlotCode): void
    }
    export interface GLTFExtensionProfile {
        readonly name: string
        readonly preloads: {
            [path: string]: (
                raw: string,
                extensionGlobal: object,
                prerequisites?: object
            ) => Promise<any>
        }
        readonly postBuild?: (root: any, extensionGlobal: object) => void
        readonly slotCodeMap: Map<string, SlotCode>
        readonly forceSlotCodeMap: Map<string, ForceSlotCode>
        readonly rootInit: (raw: object, extensionGlobal: object) => void
    }
    export type GLTFExtensionsProfiles = {
        [name: string]: GLTFExtensionProfile
    }
    export {}
}

declare module 'XrFrame/loader/glTF/geometry/GLTFMeshesNode' {
    import { Kanata } from 'XrFrame/ext'
    import { GLTFAccessorsLoaded } from 'XrFrame/loader/glTF/buffers/GLTFAccessorsNode'
    import { GLTFArrayNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import { GLTFMaterialsLoaded } from 'XrFrame/loader/glTF/materials/GLTFMaterialsNode'
    import GLTFMeshNode, {
        GLTFMeshLoaded,
        GLTFMeshNodeRaw
    } from 'XrFrame/loader/glTF/geometry/GLTFMeshNode'
    type ChildNode = GLTFMeshNode
    export type GLTFMeshesNodeRaw = GLTFMeshesNodeRaw[]
    export type GLTFMeshesLoaded = GLTFMeshLoaded[]
    export default class GLTFMeshesNode extends GLTFArrayNode<ChildNode> {
        ChildCtor(childRaw: GLTFMeshNodeRaw): GLTFMeshNode
        readonly raw: GLTFMeshesNodeRaw
        get nodeName(): string
        preload: (
            prerequisites: [
                materials: GLTFMaterialsLoaded,
                accessors: GLTFAccessorsLoaded,
                vbMap: Map<string, [ArrayBuffer, Kanata.VertexLayout, object]>
            ]
        ) => Promise<GLTFMeshesLoaded>
        getLoadedResource(): GLTFMeshesLoaded
    }
    export {}
}

declare module 'XrFrame/loader/glTF/GLTFBaseNode' {
    type Scene = import('XrFrame/core/Scene').default
    function _empty(): {
        and: typeof _empty
    }
    export abstract class GLTFBaseNode {
        readonly raw: any
        abstract get nodeName(): string
        parent: GLTFBaseNode
        scene: Scene
        isValid: boolean
        constructor(raw: object, parent?: GLTFBaseNode)
        /**
         * 对raw进行校验。
         * @deprecated 校验的事情还是交给官方的工具来做吧，规则太多了。
         */
        validate(): void
        /**
         * 利用raw生成子节点
         */
        abstract build(): void
        /**
         * @param msg 需要带句号
         */
        protected assert(
            pred: any,
            msg?: string
        ):
            | this
            | {
                  and: typeof _empty
              }
        /** @internal */
        and: (
            pred: any,
            msg?: string
        ) =>
            | this
            | {
                  and: typeof _empty
              }
        /**
         * 加载静态资源，buffer/image等。
         * 所有错误在这个方法抛出，包括格式错误，加载错误等。
         */
        abstract preload(prerequisites?: object): Promise<object>
        /**
         * 获取加载后的资源。
         * 无报错 throws nothing。
         */
        abstract getLoadedResource(): object
        protected findRoot(withPath?: boolean): any
        getExtensionRaw(extName: string): object | undefined
        /**
         * 调用这个函数可以放置一个**允许extension代码插入**的位置。
         */
        protected extensionSlot(id: string, args: object): Promise<void>
        releaseLoadedResource(): void
    }
    export abstract class GLTFArrayNode<
        T extends GLTFBaseNode
    > extends GLTFBaseNode {
        abstract readonly raw: object[]
        abstract ChildCtor(childRaw: object): T
        children: T[]
        protected resources: any[]
        validate(): void
        preload(prerequisites?: any): Promise<any>
        build(): void
        releaseLoadedResource(): void
    }
    export {}
}

declare module 'XrFrame/loader/glTF/materials/GLTFMaterialsNode' {
    import { GLTFArrayNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import { GLTFTexturesLoaded } from 'XrFrame/loader/glTF/textures/GLTFTexturesNode'
    import GLTFMaterialNode, {
        GLTFMaterialLoaded,
        GLTFMaterialNodeRaw
    } from 'XrFrame/loader/glTF/materials/GLTFMaterialNode'
    type ChildNode = GLTFMaterialNode
    export type GLTFMaterialsNodeRaw = GLTFMaterialsNodeRaw[]
    export type GLTFMaterialsLoaded = GLTFMaterialLoaded[]
    export default class GLTFMaterialsNode extends GLTFArrayNode<ChildNode> {
        ChildCtor(childRaw: GLTFMaterialNodeRaw): GLTFMaterialNode
        readonly raw: GLTFMaterialsNodeRaw
        get nodeName(): string
        preload: (
            prerequisites: [textrues: GLTFTexturesLoaded]
        ) => Promise<GLTFMaterialsLoaded>
        getLoadedResource(): GLTFMaterialsLoaded
    }
    export {}
}

declare module 'XrFrame/loader/glTF/scenes/GLTFSceneNode' {
    import { GLTFBaseNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import {
        GLTFNodesLoaded,
        GLTFTreeNode
    } from 'XrFrame/loader/glTF/scenes/GLTFNodesNode'
    export interface GLTFSceneNodeRaw {
        nodes?: number[]
        name?: string
    }
    export type GLTFSceneLoaded = GLTFTreeNode[]
    export default class GLTFSceneNode extends GLTFBaseNode {
        get nodeName(): string
        readonly raw: GLTFSceneNodeRaw
        build(): void
        preload(
            prerequisites: [nodes: GLTFNodesLoaded]
        ): Promise<GLTFSceneLoaded>
        getLoadedResource(): GLTFSceneLoaded
    }
}

declare module 'XrFrame/loader/glTF/scenes/GLTFScenesNode' {
    import { GLTFArrayNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import { GLTFNodesLoaded } from 'XrFrame/loader/glTF/scenes/GLTFNodesNode'
    import GLTFSceneNode, {
        GLTFSceneLoaded,
        GLTFSceneNodeRaw
    } from 'XrFrame/loader/glTF/scenes/GLTFSceneNode'
    type ChildNode = GLTFSceneNode
    export type GLTFScenesNodeRaw = GLTFScenesNodeRaw[]
    export type GLTFScenesLoaded = GLTFSceneLoaded[]
    export default class GLTFScenesNode extends GLTFArrayNode<ChildNode> {
        ChildCtor(childRaw: GLTFSceneNodeRaw): GLTFSceneNode
        readonly raw: GLTFScenesNodeRaw
        get nodeName(): string
        preload: (
            prerequisites: [nodes: GLTFNodesLoaded]
        ) => Promise<GLTFScenesLoaded>
        getLoadedResource(): GLTFScenesLoaded
    }
    export {}
}

declare module 'XrFrame/loader/glTF/skins/GLTFSkinsNode' {
    import { GLTFAccessorsLoaded } from 'XrFrame/loader/glTF/buffers/GLTFAccessorsNode'
    import { GLTFArrayNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import GLTFSkinNode, {
        GLTFSkinLoaded,
        GLTFSkinNodeRaw
    } from 'XrFrame/loader/glTF/skins/GLTFSkinNode'
    type ChildNode = GLTFSkinNode
    export type GLTFSkinsNodeRaw = GLTFSkinsNodeRaw[]
    export type GLTFSkinsLoaded = GLTFSkinLoaded[]
    export default class GLTFSkinsNode extends GLTFArrayNode<ChildNode> {
        ChildCtor(childRaw: GLTFSkinNodeRaw): GLTFSkinNode
        readonly raw: GLTFSkinsNodeRaw
        get nodeName(): string
        preload: (
            prerequisites: [accessors: GLTFAccessorsLoaded]
        ) => Promise<GLTFSkinsLoaded>
        getLoadedResource(): GLTFSkinsLoaded
    }
    export {}
}

declare module 'XrFrame/loader/glTF/textures/GLTFImagesNode' {
    import { GLTFBufferViewsLoaded } from 'XrFrame/loader/glTF/buffers/GLTFBufferViewsNode'
    import { GLTFArrayNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import GLTFImageNode, {
        GLTFImageLoaded,
        GLTFImageNodeRaw
    } from 'XrFrame/loader/glTF/textures/GLTFImageNode'
    type ChildNode = GLTFImageNode
    export type GLTFImagesNodeRaw = GLTFImagesNodeRaw[]
    export type GLTFImagesLoaded = GLTFImageLoaded[]
    export default class GLTFImagesNode extends GLTFArrayNode<ChildNode> {
        ChildCtor(childRaw: GLTFImageNodeRaw): GLTFImageNode
        readonly raw: GLTFImagesNodeRaw
        get nodeName(): string
        preload: (
            prerequisites: [bufferViews: GLTFBufferViewsLoaded]
        ) => Promise<GLTFImagesLoaded>
        getLoadedResource(): GLTFImagesLoaded
    }
    export {}
}

declare module 'XrFrame/loader/glTF/textures/GLTFSamplersNode' {
    import { GLTFArrayNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import GLTFSamplerNode, {
        GLTFSamplerLoaded,
        GLTFSamplerNodeRaw
    } from 'XrFrame/loader/glTF/textures/GLTFSamplerNode'
    type ChildNode = GLTFSamplerNode
    export type GLTFSamplersNodeRaw = GLTFSamplersNodeRaw[]
    export type GLTFSamplersLoaded = GLTFSamplerLoaded[]
    export default class GLTFSamplersNode extends GLTFArrayNode<ChildNode> {
        ChildCtor(childRaw: GLTFSamplerNodeRaw): GLTFSamplerNode
        readonly raw: GLTFSamplersNodeRaw
        get nodeName(): string
        preload: () => Promise<GLTFSamplersLoaded>
        getLoadedResource(): GLTFSamplersLoaded
    }
    export {}
}

declare module 'XrFrame/loader/glTF/textures/GLTFTexturesNode' {
    import { GLTFArrayNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import { GLTFImagesLoaded } from 'XrFrame/loader/glTF/textures/GLTFImagesNode'
    import { GLTFSamplersLoaded } from 'XrFrame/loader/glTF/textures/GLTFSamplersNode'
    import GLTFTextureNode, {
        GLTFTextureLoaded,
        GLTFTextureNodeRaw
    } from 'XrFrame/loader/glTF/textures/GLTFTextureNode'
    type ChildNode = GLTFTextureNode
    export type GLTFTexturesNodeRaw = GLTFTexturesNodeRaw[]
    export type GLTFTexturesLoaded = GLTFTextureLoaded[]
    export default class GLTFTexturesNode extends GLTFArrayNode<ChildNode> {
        ChildCtor(childRaw: GLTFTextureNodeRaw): GLTFTextureNode
        readonly raw: GLTFTexturesNodeRaw
        get nodeName(): string
        preload: (
            prerequisites: [
                images: GLTFImagesLoaded,
                samplers: GLTFSamplersLoaded
            ]
        ) => Promise<GLTFTexturesLoaded>
        getLoadedResource(): GLTFTexturesLoaded
    }
    export {}
}

declare module 'XrFrame/loader/glTF/scenes/GLTFNodeNode' {
    import { GLTFMeshesLoaded } from 'XrFrame/loader/glTF/geometry/GLTFMeshesNode'
    import { GLTFMeshLoaded } from 'XrFrame/loader/glTF/geometry/GLTFMeshNode'
    import { GLTFBaseNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import { GLTFSkinLoaded } from 'XrFrame/loader/glTF/skins/GLTFSkinNode'
    import { GLTFSkinsLoaded } from 'XrFrame/loader/glTF/skins/GLTFSkinsNode'
    import { GLTF } from 'XrFrame/loader/glTF/utils/types'
    export interface GLTFNodeNodeRaw {
        children?: number[]
        mesh?: number
        matrix?: number[]
        rotation?: [number, number, number, number]
        scale?: [number, number, number]
        translation?: [number, number, number]
        weights?: number
        skin?: number
        name?: string
        extension?: object
    }
    export interface GLTFNodeLoaded {
        children: number[]
        transform: GLTF.Transform
        mesh?: GLTFMeshLoaded
        skin?: GLTFSkinLoaded
        name: string
    }
    export type GLTFNodePrerequisites = [
        meshes: GLTFMeshesLoaded,
        skins: GLTFSkinsLoaded
    ]
    export default class GLTFNodeNode extends GLTFBaseNode {
        get nodeName(): string
        readonly raw: GLTFNodeNodeRaw
        build(): void
        preload(prerequisites: GLTFNodePrerequisites): Promise<GLTFNodeLoaded>
        getLoadedResource(): GLTFNodeLoaded
    }
}

declare module 'XrFrame/kanata/lib/frontend/component/MeshRendererComponent' {
    /**
     * MeshRendererComponent.ts
     *
     *       * @Date    : 9/3/2020, 7:54:23 PM
     */
    import { EMeshRenderType } from 'XrFrame/kanata/lib/backend'
    import NativeObject from 'XrFrame/kanata/lib/frontend/shared/NativeObject'
    import Entity3D from 'XrFrame/kanata/lib/frontend/entity/Entity3D'
    import Entity2D from 'XrFrame/kanata/lib/frontend/entity/Entity2D'
    import UniformBlock from 'XrFrame/kanata/lib/frontend/resource/UniformBlock'
    import VertexBuffer from 'XrFrame/kanata/lib/frontend/resource/VertexBuffer'
    import IndexBuffer from 'XrFrame/kanata/lib/frontend/resource/IndexBuffer'
    import VertexData from 'XrFrame/kanata/lib/frontend/resource/VertexData'
    import IndexData from 'XrFrame/kanata/lib/frontend/resource/IndexData'
    import Material from 'XrFrame/kanata/lib/frontend/resource/Material'
    import SkinnedSkeletonComponent from 'XrFrame/kanata/lib/frontend/component/SkinnedSkeletonComponent'
    import CullingComponent from 'XrFrame/kanata/lib/frontend/component/CullingComponent'
    export default class MeshRendererComponent extends NativeObject {
        static OFFSETS: {
            dynamicBatch: number
            skinHandle: number
            castShadow: number
            bindTarget: number
            start: number
            size: number
            materialId: number
            vertexBufferId: number
            indexBufferId: number
            startIndex: number
            numIndices: number
        }
        static CREATE_FAKE(
            entity: Entity3D | Entity2D,
            options: {
                meshCount: number
                uniformBlock?: UniformBlock
            }
        ): FakeMeshRenderComponent
        protected _uniforms: UniformBlock
        get uniforms(): UniformBlock
        get meshCount(): number
        get castShadow(): boolean
        set castShadow(value: boolean)
        get dynamicBatch(): boolean
        set dynamicBatch(value: boolean)
        set skinSkeleton(sk: SkinnedSkeletonComponent)
        set bindTarget(target: Entity3D | Entity2D | null)
        get macros(): {
            [name: string]: string | number | boolean
        }
        constructor(
            entity: Entity3D | Entity2D,
            options: {
                meshCount: number
                uniformBlock: UniformBlock
                renderType: EMeshRenderType
                culling?: CullingComponent
                macros?: {
                    [name: string]: string | number | boolean
                }
            }
        )
        protected _createNativeObj(
            entity: Entity3D | Entity2D,
            options: {
                meshCount: number
                uniformBlock: UniformBlock
                renderType: EMeshRenderType
                culling?: CullingComponent
                macros?: {
                    [name: string]: string | number | boolean
                }
            }
        ): import('XrFrame/kanata/lib/backend').IHandle & {
            setSharedDirty(): void
        }
        changeMacros(macros?: {
            [name: string]: string | number | boolean
        }): void
        getStartIndex(index: number): number
        setStartIndex(index: number, value: number): void
        getNumIndices(index: number): number
        setNumIndices(index: number, value: number): void
        getVertexBuffer(index: number): VertexBuffer
        setVertexBuffer(index: number, buffer: VertexBuffer): void
        getIndexBuffer(index: number): IndexBuffer
        setIndexBuffer(index: number, buffer: IndexBuffer): void
        getVertexData(index: number): VertexData
        setVertexData(index: number, buffer: VertexData): void
        getIndexData(index: number): IndexData
        setIndexData(index: number, buffer: IndexData): void
        getMaterial(index: number): Material
        setMaterial(index: number, material: Material | null): void
        fastSet(
            vertexes: Array<VertexBuffer | VertexData>,
            indexes: Array<VertexData | IndexBuffer>,
            materials: Material[],
            startIndexes: number[],
            numIndices: number[]
        ): void
        setDirty(): void
        copyStates(comp: MeshRendererComponent): void
    }
    class FakeMeshRenderComponent extends MeshRendererComponent {
        protected _createNativeObj(
            entity: Entity3D | Entity2D,
            options: {
                meshCount: number
                uniformBlock: UniformBlock
                renderType: EMeshRenderType
                culling: CullingComponent
            }
        ): {
            id: number
            data: ArrayBuffer
            setSharedDirty: () => void
        }
        get uniforms(): UniformBlock
        set uniforms(uniforms: UniformBlock)
    }
    export {}
}

declare module 'XrFrame/kanata/lib/frontend/resource/renderEnv' {
    /**
     * renderEnv.ts
     *
     *       * @Date    : 1/18/2021, 3:53:26 PM
     */
    import {
        EMeshRenderType,
        EUniformType,
        IFeatures,
        IRenderEnv,
        TCompressTexture
    } from 'XrFrame/kanata/lib/backend'
    import View from 'XrFrame/kanata/lib/frontend/resource/View'
    import Effect from 'XrFrame/kanata/lib/frontend/resource/Effect'
    import RenderPass from 'XrFrame/kanata/lib/frontend/resource/RenderPass'
    import UniformBlock from 'XrFrame/kanata/lib/frontend/resource/UniformBlock'
    export class RenderEnv {
        id: number
        __handle: IRenderEnv
        useExtendedMemory: boolean
        get version(): number[]
        get backendType(): string
        get canvasWidth(): number
        set canvasWidth(value: number)
        get canvasHeight(): number
        set canvasHeight(value: number)
        get supportCompressTextures(): TCompressTexture[]
        get features(): IFeatures
        get commitVersion(): string
        get usePuppetSokol(): boolean
        get useInstance(): boolean
        set useInstance(value: boolean)
        get neverTranspose(): boolean
        set neverTranspose(value: boolean)
        get isWrongWrapMapping(): boolean
        get isNotWrongEffectSort(): boolean
        get isGoodInstance(): boolean
        get isGoodPhysAndScalableList(): boolean
        constructor()
        supportCompressTexture(type: TCompressTexture): boolean
        registerFallbackEffect(lightMode: string, effect?: Effect): void
        beginFrame(): void
        endFrame(): void
        clearView(view: View): void
        setEnvUniform(index: number, uniforms: UniformBlock): void
        setRenderPass(renderPass: RenderPass): void
        changeMacros(macros: {
            [name: string]: string | number | boolean
        }): void
        getMacro(key: string): string | number | boolean
        changeVirtualMacros(macros: { [name: string]: boolean }): void
        getVirtualMacro(key: string): boolean
        setInternalInstanceInfo(
            type: EMeshRenderType,
            info: Array<{
                uniformKey: string
                attributeName: string
                type: EUniformType
            }>,
            ignored: string[]
        ): void
        getErrors(): string[]
    }
    const renderEnv: RenderEnv
    export default renderEnv
}

declare module 'XrFrame/kanata/lib/frontend/component/AnimatorComponent' {
    import NativeObject from 'XrFrame/kanata/lib/frontend/shared/NativeObject'
    import Entity3D from 'XrFrame/kanata/lib/frontend/entity/Entity3D'
    import AnimationClipModel from 'XrFrame/kanata/lib/frontend/resource/AnimationClipModel'
    export default class AnimatorComponent extends NativeObject {
        static UPDATE_ANIMATORS(
            animators: AnimatorComponent[],
            size: number
        ): void
        animationClipModels: AnimationClipModel[]
        constructor()
        bindAnimations(
            animationClipModels: AnimationClipModel[],
            entities: Array<Array<Entity3D | null>>,
            rootEntity?: Entity3D
        ): void
        setClipParams(
            index: number,
            frameIndex: number,
            blendWeight: number
        ): void
        getAnimationClipCount(): number
        getNodeCount(): number
        getAnimationParameter(index: number): {
            animationClipId: number
            frameIndex: number
            percentage: number
        }
        getEntity(index: number): number
    }
}

declare module 'XrFrame/kanata/lib/frontend/component/CameraComponent' {
    import NativeObject from 'XrFrame/kanata/lib/frontend/shared/NativeObject'
    import Entity3D from 'XrFrame/kanata/lib/frontend/entity/Entity3D'
    import Entity2D from 'XrFrame/kanata/lib/frontend/entity/Entity2D'
    import View from 'XrFrame/kanata/lib/frontend/resource/View'
    import ScalableList from 'XrFrame/kanata/lib/frontend/resource/ScalableList'
    export default class CameraComponent extends NativeObject {
        static OFFSETS: {
            size: number
            view: number
            depth: number
            active: number
            fov: number
            aspect: number
            near: number
            far: number
            up: number
            eye: number
            orthoSize: number
            isProjection: number
            cullingMask: number
            canvasSizeY: number
            targetTransform: number
            viewMatrix: number
            projectionMatrix: number
            viewMatrixInverse: number
            viewMatrix2D: number
            projectionMatrix2D: number
            viewMatrixInverse2D: number
            manualMatrix: number
            layerCullDistances: number
        }
        get active(): boolean
        set active(value: boolean)
        get depth(): number
        set depth(value: number)
        get isProjection(): boolean
        set isProjection(value: boolean)
        get view(): View
        set view(value: View)
        get fov(): number
        set fov(value: number)
        get aspect(): number
        set aspect(value: number)
        get near(): number
        set near(value: number)
        get far(): number
        set far(value: number)
        get orthoSize(): number
        set orthoSize(value: number)
        get cullingMask(): number
        set cullingMask(value: number)
        get layerCullDistances(): Float32Array | number[]
        set layerCullDistances(value: Float32Array | number[])
        get canvasSizeY(): number
        set canvasSizeY(value: number)
        set targetTransform(entityId: number)
        get targetTransform(): number
        set up(vec3: Float32Array)
        constructor(entity: Entity2D | Entity3D, isUI?: boolean)
        cull(cullResult: ScalableList, lightMode: string): void
        draw(renderList: ScalableList, lightMode: string): void
        changeProjectionMatrix(manual: boolean, mat4?: Float32Array): void
        changeViewMatrix(manual: boolean, mat4?: Float32Array): void
        updateMatrix(): void
    }
}

declare module 'XrFrame/kanata/lib/frontend/component/LightCameraComponent' {
    /**
     * CameraLightComponent.ts
     *
     *       * @Date    : 9/3/2020, 7:54:13 PM
     */
    import { EShadowMode } from 'XrFrame/kanata/lib/backend'
    import NativeObject from 'XrFrame/kanata/lib/frontend/shared/NativeObject'
    import View from 'XrFrame/kanata/lib/frontend/resource/View'
    import UniformBlock from 'XrFrame/kanata/lib/frontend/resource/UniformBlock'
    import ScalableList from 'XrFrame/kanata/lib/frontend/resource/ScalableList'
    import CameraComponent from 'XrFrame/kanata/lib/frontend/component/CameraComponent'
    export default class LightCameraComponent extends NativeObject {
        static OFFSETS: {
            size: number
            view: number
            depth: number
            active: number
            shadowDistance: number
            shadowMode: number
            shadowFilterMode: number
            lightDir: number
            bounds: number
            lightSpaceMatrices: number
        }
        get view(): View
        set view(value: View)
        get active(): boolean
        set active(value: boolean)
        get depth(): number
        set depth(value: number)
        get shadowDistance(): number
        set shadowDistance(value: number)
        get shadowFilterMode(): number
        set shadowFilterMode(value: number)
        get shadowMode(): EShadowMode
        set shadowMode(value: EShadowMode)
        get lightSpaceMatrices(): Float32Array
        constructor()
        draw(
            camera: CameraComponent,
            renderList: ScalableList,
            lightMode: string
        ): void
        prepareUniforms(uniforms: UniformBlock): void
        setLightDir(x: number, y: number, z: number): void
        setCascadedSplits(s0: number, s1: number, s2: number): void
        protected _updateBounds(auto: boolean): void
        protected _adjustSplitPercents(index: number, percent: number): number
        protected _setSplitPercents(index: number, percent: number): number
    }
}

declare module 'XrFrame/kanata/lib/frontend/component/CullingComponent' {
    import Entity3D from 'XrFrame/kanata/lib/frontend/entity/Entity3D'
    import Entity2D from 'XrFrame/kanata/lib/frontend/entity/Entity2D'
    import PoolObject from 'XrFrame/kanata/lib/frontend/pool/PoolObject'
    import PoolManager from 'XrFrame/kanata/lib/frontend/pool/PoolManager'
    export default class CullingComponent extends PoolObject {
        static POLL_MANAGER: PoolManager
        constructor(entity: Entity2D | Entity3D)
        getActive(): boolean
        setActive(val: boolean): void
        getLayer(): number
        setLayer(val: number): void
        getBoundingBallCenter(): Float32Array
        setBoundingBallCenter(val: Float32Array, offset?: number): void
        getBoundingBallRadius(): number
        setBoundingBallRadius(val: number): void
        bindEntity(entity: Entity2D | Entity3D): void
        destroy(): void
    }
}

declare module 'XrFrame/kanata/lib/frontend/component/SkinnedSkeletonComponent' {
    import NativeObject from 'XrFrame/kanata/lib/frontend/shared/NativeObject'
    import SkeletonBoneInverseModel from 'XrFrame/kanata/lib/frontend/resource/SkeletonBoneInverseModel'
    import Entity3D from 'XrFrame/kanata/lib/frontend/entity/Entity3D'
    export default class SkinnedSkeletonComponent extends NativeObject {
        static UPDATE_MATS(
            comps: SkinnedSkeletonComponent[],
            size: number
        ): void
        get boneNum(): number
        get boneInverseModel(): SkeletonBoneInverseModel
        get boneOffsetMatrices(): Float32Array
        constructor(boneNum: number, flag: number)
        setBoneMatrix(
            boneInverseModel: SkeletonBoneInverseModel,
            boneIndices: number[],
            boneEntities: Entity3D[]
        ): void
        getBoneNum(): number
        getBoneOffsetMatrices(): Float32Array
    }
}

declare module 'XrFrame/kanata/lib/frontend/component/DynamicBonesComponent' {
    import NativeObject from 'XrFrame/kanata/lib/frontend/shared/NativeObject'
    import Entity3D from 'XrFrame/kanata/lib/frontend/entity/Entity3D'
    export default class DynamicBonesComponent extends NativeObject {
        static OFFSETS: {
            stiffness: number
            elasticity: number
            damping: number
        }
        get stiffness(): number
        set stiffness(v: number)
        get damping(): number
        set damping(v: number)
        get elasticity(): number
        set elasticity(v: number)
        constructor(rootNode?: Entity3D)
        preUpdate(): void
        update(
            dt: number,
            rootMotion?: {
                x: number
                y: number
                z: number
            }
        ): void
        rebuild(): void
        resetRoot(root?: Entity3D): void
    }
}

declare module 'XrFrame/kanata/lib/frontend/entity/Entity2D' {
    import PoolObject from 'XrFrame/kanata/lib/frontend/pool/PoolObject'
    import PoolManager from 'XrFrame/kanata/lib/frontend/pool/PoolManager'
    export default class Entity2D extends PoolObject {
        static POLL_MANAGER: PoolManager
        static OFFSETS: {
            size: number
            rotation: number
            position: number
            scale: number
            worldMatrix: number
        }
        localPositionOffset: number
        localRotationOffset: number
        localScaleOffset: number
        worldMatrixOffset: number
        constructor()
        addChild(child: Entity2D): void
        addChildAtIndex(child: Entity2D, index: number): void
        removeFromParent(): void
        setAsRoot(): void
        destroy(): void
        clear(): void
        setLocalMatrixDirty(): void
        set active(val: boolean)
    }
}

declare module 'XrFrame/kanata/lib/frontend/entity/Entity3D' {
    import PoolObject from 'XrFrame/kanata/lib/frontend/pool/PoolObject'
    import PoolManager from 'XrFrame/kanata/lib/frontend/pool/PoolManager'
    export default class Entity3D extends PoolObject {
        static POLL_MANAGER: PoolManager
        static OFFSETS: {
            size: number
            dfRotationType: number
            rotationType: number
            rotation: number
            position: number
            scale: number
            worldOffset: number
            worldMatrix: number
        }
        static CREATE_TREE(
            length: number,
            buffer: ArrayBuffer,
            out: any[],
            calculateWordMatrix?: boolean
        ): boolean
        localRotationTypeOffset: number
        localQuaternionOffset: number
        localPositionOffset: number
        localScaleOffset: number
        worldMatrixOffset: number
        extOffset: number
        layerOffset: number
        mixedLayerMaskOffset: number
        constructor()
        setUsingEuler(on: boolean): void
        isUsingEuler(): boolean
        setLayer(layer: number): void
        getLayer(): number
        getMixedLayerMask(): number
        addChild(child: Entity3D): void
        addChildAtIndex(child: Entity3D, index: number): void
        removeFromParent(): void
        setAsRoot(): void
        destroy(): void
        /**
         * 如果只调用entityClear指令，那么Kanata就无法回收根节点下面的子节点了。
         * 目前Kanata的frontend没有父子关系信息只能这么做了。
         * 这个方法目前只能减少eventBridge的指令量，避免在大规模节点销毁的时候频繁触发eventBridge的溢出提交。
         * @param entities
         * @param length
         */
        clear(entities: Entity3D[], length: number): void
        setLocalMatrixDirty(): void
        set active(val: boolean)
    }
}

declare module 'XrFrame/kanata/lib/frontend/resource/AnimationClipModel' {
    import DataModel from 'XrFrame/kanata/lib/frontend/resource/DataModel'
    export default class AnimationClipModel extends DataModel {
        setAnimationClip(ab: ArrayBuffer): void
    }
}

declare module 'XrFrame/kanata/lib/frontend/resource/AnimationClipBinding' {
    /**
     * AnimationClipBinding.ts
     *
     *       */
    import Entity3D from 'XrFrame/kanata/lib/frontend/entity/Entity3D'
    import AnimationClipModel from 'XrFrame/kanata/lib/frontend/resource/AnimationClipModel'
    import { EUseDefaultAddedAction } from 'XrFrame/kanata/lib/backend'
    import PureResource from 'XrFrame/kanata/lib/frontend/shared/PureResource'
    import { INativeWorker } from 'XrFrame/kanata/lib/backend/native/worker'
    export default class AnimationClipBinding extends PureResource {
        __handle: INativeWorker.IAnimationClipBinding
        constructor(
            clipArray: AnimationClipModel[],
            clipArrayOffset: number,
            clipArrayLength: number,
            entityArray: Array<number | Entity3D | null>,
            entityArrayOffset: number,
            entityArrayLength: number,
            useDefaultAddedNodesAction: EUseDefaultAddedAction,
            rootEntity: Entity3D
        )
        rebind(
            clipArray: AnimationClipModel[],
            clipArrayOffset: number,
            clipArrayLength: number,
            entityArray: Array<number | Entity3D | null>,
            entityArrayOffset: number,
            entityArrayLength: number,
            removeAction: number,
            retainedAction: number,
            addedAction: number,
            rootEntity: Entity3D
        ): boolean
        update(
            clipArray: AnimationClipModel[],
            clipArrayOffset: number,
            clipArrayLength: number,
            entityArray: Array<number | Entity3D | null>,
            entityArrayOffset: number,
            entityArrayLength: number,
            removeAction: number,
            retainedAction: number,
            addedAction: number
        ): boolean
        writeDefaultValues(): void
    }
}

declare module 'XrFrame/kanata/lib/frontend/resource/AnimatorControllerModel' {
    /**
     * AnimatorControllerModel.ts
     *
     *       */
    import AnimatorControllerStateModel from 'XrFrame/kanata/lib/frontend/resource/AnimatorControllerStateModel'
    import PureResource from 'XrFrame/kanata/lib/frontend/shared/PureResource'
    import AnimationClipBinding from 'XrFrame/kanata/lib/frontend/resource/AnimationClipBinding'
    export default class AnimatorControllerModel extends PureResource {
        layerCount: number
        static UPDATE_ANIMATOR_CONTROLLERS(
            animatorControllers: AnimatorControllerModel[],
            size: number
        ): void
        constructor(layerCount: number)
        setAnimationClipBinding(binding: null | AnimationClipBinding): void
        setLayerBlendType(layerIndex: number, blendType: number): void
        setLayerWeight(layerIndex: number, weight: number): void
        setLayerBlend(
            layerIndex: number,
            blend: null | AnimatorControllerStateModel
        ): void
        setLayerMask(
            layerIndex: number,
            mask: {
                buffer: null | ArrayBuffer
                offset: number
                length: number
            }
        ): void
        update(): void
        destroy(): void
    }
}

declare module 'XrFrame/kanata/lib/frontend/resource/AnimatorControllerStateModel' {
    import PureResource from 'XrFrame/kanata/lib/frontend/shared/PureResource'
    import AnimationClipModel from 'XrFrame/kanata/lib/frontend/resource/AnimationClipModel'
    export default class AnimatorControllerStateModel extends PureResource {
        readonly count: number
        get weight(): number
        set weight(weight: number)
        get useDefault(): number
        set useDefault(useDefault: number)
        constructor(count: number)
        resetBlendInfo(): void
        setNextState(state: AnimatorControllerStateModel | null): void
        setBlendInfo(
            clip: AnimationClipModel,
            frameIndex: number,
            blendWeight: number,
            additiveReferenceClip: null | AnimationClipModel,
            additiveFrameIndex: number
        ): boolean
    }
}

declare module 'XrFrame/kanata/lib/frontend/resource/DataBuffer' {
    /**
     * DataBuffer.ts
     *
     *       * @Date    : 9/4/2020, 1:21:59 PM
     */
    import { IHandle } from 'XrFrame/kanata/lib/backend'
    import NativeObject from 'XrFrame/kanata/lib/frontend/shared/NativeObject'
    export default class DataBuffer extends NativeObject {
        constructor(nativeObj: IHandle)
        get dataLength(): number
        get byteOffset(): number
        get arrayBuffer(): ArrayBuffer
    }
}

declare module 'XrFrame/kanata/lib/frontend/resource/DataModel' {
    /**
     * DataModel.ts
     *
     *       * @Date    : 9/4/2020, 1:18:13 PM
     */
    import { EDataModelType } from 'XrFrame/kanata/lib/backend'
    import PureResource from 'XrFrame/kanata/lib/frontend/shared/PureResource'
    export default class DataModel extends PureResource {
        protected _createNativeModel(
            type: EDataModelType,
            buffer: ArrayBuffer
        ): void
    }
}

declare module 'XrFrame/kanata/lib/frontend/resource/Effect' {
    /**
     * Effect.ts
     *
     *       * @Date    : 9/9/2020, 5:49:54 PM
     */
    import {
        EBlendFactor,
        EBlendEquation,
        ECullMode,
        ECompareFunc,
        EPrimitiveType,
        EStencilOp
    } from 'XrFrame/kanata/lib/backend'
    import NativeObject from 'XrFrame/kanata/lib/frontend/shared/NativeObject'
    export default class Effect extends NativeObject {
        static OFFSETS: {
            size: number
            useMaterialStates: number
            fstencil: number
            bstencil: number
            blendRGBA: number
            colorDepth: number
            state: number
        }
        get passCount(): number
        constructor(
            name: string,
            passCount: number,
            keyIndexMap: string[],
            passes: Array<{
                lightMode: string
                variants?: {
                    [key: number]: number
                }
                macros?: {
                    [key: string]: number
                }
                shaders?: number[]
            }>,
            shaders: string[],
            variants: number[][],
            useRuntimeMacros?: boolean
        )
        warmUp(): any
        getBlendOn(pass: number): boolean
        setBlendOn(pass: number, value: boolean): void
        getBlendSrc(pass: number): EBlendFactor
        setBlendSrc(pass: number, value: EBlendFactor): void
        getBlendDst(pass: number): EBlendFactor
        setBlendDst(pass: number, value: EBlendFactor): void
        getBlendSrcRGB(pass: number): EBlendFactor
        setBlendSrcRGB(pass: number, value: EBlendFactor): void
        getBlendSrcAlpha(pass: number): EBlendFactor
        setBlendSrcAlpha(pass: number, value: EBlendFactor): void
        getBlendDstRGB(pass: number): EBlendFactor
        setBlendDstRGB(pass: number, value: EBlendFactor): void
        getBlendDstAlpha(pass: number): EBlendFactor
        setBlendDstAlpha(pass: number, value: EBlendFactor): void
        getBlendFunc(pass: number): EBlendEquation
        setBlendFunc(pass: number, value: EBlendEquation): void
        getDepthTestOn(pass: number): boolean
        setDepthTestOn(pass: number, value: boolean): void
        getDepthTestComp(pass: number): ECompareFunc
        setDepthTestComp(pass: number, value: ECompareFunc): void
        getDepthWrite(pass: number): boolean
        setDepthWrite(pass: number, value: boolean): void
        getCullFace(pass: number): ECullMode
        setCullFace(pass: number, value: ECullMode): void
        getCullOn(pass: number): boolean
        setCullOn(pass: number, value: boolean): void
        getPrimitiveType(pass: number): EPrimitiveType
        setPrimitiveType(pass: number, value: EPrimitiveType): void
        getStencilTestOn(pass: number): boolean
        setStencilTestOn(pass: number, value: boolean): void
        getStencilComp(pass: number): ECompareFunc
        setStencilComp(pass: number, value: ECompareFunc): void
        getStencilPass(pass: number): EStencilOp
        setStencilPass(pass: number, value: EStencilOp): void
        getStencilFail(pass: number): EStencilOp
        setStencilFail(pass: number, value: EStencilOp): void
        getStencilZFail(pass: number): EStencilOp
        setStencilZFail(pass: number, value: EStencilOp): void
        getStencilWriteMask(pass: number): number
        setStencilWriteMask(pass: number, value: number): void
        getStencilReadMask(pass: number): number
        setStencilReadMask(pass: number, value: number): void
        getStencilRef(pass: number): number
        setStencilRef(pass: number, value: number): void
        getUseMaterialStates(pass: number): boolean
        setUseMaterialStates(pass: number, value: boolean): void
        getUseMaterialStateBlendOn(pass: number): boolean
        setUseMaterialStateBlendOn(pass: number, value: boolean): void
        getUseMaterialStateBlendSrcRGB(pass: number): boolean
        setUseMaterialStateBlendSrcRGB(pass: number, value: boolean): void
        getUseMaterialStateBlendSrcAlpha(pass: number): boolean
        setUseMaterialStateBlendSrcAlpha(pass: number, value: boolean): void
        getUseMaterialStateBlendDstRGB(pass: number): boolean
        setUseMaterialStateBlendDstRGB(pass: number, value: boolean): void
        getUseMaterialStateBlendDstAlpha(pass: number): boolean
        setUseMaterialStateBlendDstAlpha(pass: number, value: boolean): void
        getUseMaterialStateBlendFunc(pass: number): boolean
        setUseMaterialStateBlendFunc(pass: number, value: boolean): void
        getUseMaterialStateDepthTestOn(pass: number): boolean
        setUseMaterialStateDepthTestOn(pass: number, value: boolean): void
        getUseMaterialStateDepthTestComp(pass: number): boolean
        setUseMaterialStateDepthTestComp(pass: number, value: boolean): void
        getUseMaterialStateDepthWrite(pass: number): boolean
        setUseMaterialStateDepthWrite(pass: number, value: boolean): void
        getUseMaterialStateCullOn(pass: number): boolean
        setUseMaterialStateCullOn(pass: number, value: boolean): void
        getUseMaterialStateCullFace(pass: number): boolean
        setUseMaterialStateCullFace(pass: number, value: boolean): void
        getUseMaterialStatePrimitiveType(pass: number): boolean
        setUseMaterialStatePrimitiveType(pass: number, value: boolean): void
        getUseMaterialStateStencilTestOn(pass: number): boolean
        setUseMaterialStateStencilTestOn(pass: number, value: boolean): void
        getUseMaterialStateStencilTestComp(pass: number): boolean
        setUseMaterialStateStencilTestComp(pass: number, value: boolean): void
        getUseMaterialStateStencilTestPass(pass: number): boolean
        setUseMaterialStateStencilTestPass(pass: number, value: boolean): void
        getUseMaterialStateStencilTestFail(pass: number): boolean
        setUseMaterialStateStencilTestFail(pass: number, value: boolean): void
        getUseMaterialStateStencilTestZFail(pass: number): boolean
        setUseMaterialStateStencilTestZFail(pass: number, value: boolean): void
        showDebugInfo(): string
    }
}

declare module 'XrFrame/kanata/lib/frontend/resource/Material' {
    /**
     * Material.ts
     *
     *       * @Date    : 9/4/2020, 6:41:13 PM
     */
    import {
        EBlendFactor,
        EBlendEquation,
        ECompareFunc,
        ECullMode,
        EStencilOp,
        EPrimitiveType
    } from 'XrFrame/kanata/lib/backend'
    import UniformBlock from 'XrFrame/kanata/lib/frontend/resource/UniformBlock'
    import NativeObject from 'XrFrame/kanata/lib/frontend/shared/NativeObject'
    import Effect from 'XrFrame/kanata/lib/frontend/resource/Effect'
    export default class Material extends NativeObject {
        static OFFSETS: {
            size: number
            renderQueue: number
            effect: number
            uniformBlock: number
            fstencilMask: number
            bstencilMask: number
            blendRGBAMask: number
            colorDepthMask: number
            stateMask: number
            fstencil: number
            bstencil: number
            blendRGBA: number
            colorDepth: number
            state: number
            useInstance: number
        }
        protected _uniforms: UniformBlock
        protected _effect: Effect
        protected _macros: {
            [name: string]: string | number | boolean
        }
        get effect(): Effect
        set effect(value: Effect)
        get uniforms(): UniformBlock
        set uniforms(value: UniformBlock)
        get renderQueue(): number
        set renderQueue(value: number)
        get useInstance(): boolean
        set useInstance(value: boolean)
        get blendOn(): boolean
        set blendOn(value: boolean)
        get blendSrcRGB(): EBlendFactor
        set blendSrcRGB(value: EBlendFactor)
        get blendSrcRGBChanged(): boolean
        get blendSrcAlpha(): EBlendFactor
        set blendSrcAlpha(value: EBlendFactor)
        set blendSrc(value: EBlendFactor)
        get blendDstRGB(): EBlendFactor
        set blendDstRGB(value: EBlendFactor)
        get blendDstRGBChanged(): boolean
        get blendDstAlpha(): EBlendFactor
        set blendDstAlpha(value: EBlendFactor)
        set blendDst(value: EBlendFactor)
        get blendFunc(): EBlendEquation
        set blendFunc(value: EBlendEquation)
        get depthTestOn(): boolean
        set depthTestOn(value: boolean)
        get depthTestComp(): ECompareFunc
        set depthTestComp(value: ECompareFunc)
        get depthWrite(): boolean
        set depthWrite(value: boolean)
        get cullFace(): ECullMode
        set cullFace(value: ECullMode)
        get cullOn(): boolean
        set cullOn(value: boolean)
        get primitiveType(): EPrimitiveType
        set primitiveType(value: EPrimitiveType)
        get stencilTestOn(): boolean
        set stencilTestOn(value: boolean)
        get stencilComp(): ECompareFunc
        set stencilComp(value: ECompareFunc)
        get stencilPass(): EStencilOp
        set stencilPass(value: EStencilOp)
        get stencilFail(): EStencilOp
        set stencilFail(value: EStencilOp)
        get stencilZFail(): EStencilOp
        set stencilZFail(value: EStencilOp)
        get stencilWriteMask(): number
        set stencilWriteMask(value: number)
        get stencilReadMask(): number
        set stencilReadMask(value: number)
        get stencilRef(): number
        set stencilRef(value: number)
        get blendOnMask(): boolean
        set blendOnMask(value: boolean)
        get blendSrcRGBMask(): boolean
        set blendSrcRGBMask(value: boolean)
        get blendSrcAlphaMask(): boolean
        set blendSrcAlphaMask(value: boolean)
        set blendSrcMask(value: boolean)
        get blendDstRGBMask(): boolean
        set blendDstRGBMask(value: boolean)
        get blendDstAlphaMask(): boolean
        set blendDstAlphaMask(value: boolean)
        set blendDstMask(value: boolean)
        get blendFuncMask(): boolean
        set blendFuncMask(value: boolean)
        get depthTestOnMask(): boolean
        set depthTestOnMask(value: boolean)
        get depthTestCompMask(): boolean
        set depthTestCompMask(value: boolean)
        get depthWriteMask(): boolean
        set depthWriteMask(value: boolean)
        get cullFaceMask(): boolean
        set cullFaceMask(value: boolean)
        get cullOnMask(): boolean
        set cullOnMask(value: boolean)
        get primitiveTypeMask(): boolean
        set primitiveTypeMask(value: boolean)
        get stencilTestOnMask(): boolean
        set stencilTestOnMask(value: boolean)
        get stencilCompMask(): boolean
        set stencilCompMask(value: boolean)
        get stencilPassMask(): boolean
        set stencilPassMask(value: boolean)
        get stencilFailMask(): boolean
        set stencilFailMask(value: boolean)
        get stencilZFailMask(): boolean
        set stencilZFailMask(value: boolean)
        get stencilWriteMaskMask(): boolean
        set stencilWriteMaskMask(value: boolean)
        get stencilReadMaskMask(): boolean
        set stencilReadMaskMask(value: boolean)
        get stencilRefMask(): boolean
        set stencilRefMask(value: boolean)
        constructor(
            macros?: {
                [name: string]: string | number | boolean
            },
            effect?: Effect,
            uniformBlock?: UniformBlock
        )
        protected _createNativeMat(
            macros?: {
                [name: string]: string | number | boolean
            },
            effect?: Effect,
            uniformBlock?: UniformBlock
        ): void
        changeMacros(macros?: {
            [name: string]: string | number | boolean
        }): void
        getMacro(key: string): string | number | boolean
        clone(uniforms?: UniformBlock): Material
        showDebugInfo(): string
    }
}

declare module 'XrFrame/kanata/lib/frontend/resource/RenderPass' {
    import PureResource from 'XrFrame/kanata/lib/frontend/shared/PureResource'
    import Texture from 'XrFrame/kanata/lib/frontend/resource/Texture'
    export interface IRenderPassOptions {
        colors: Array<{
            texture: Texture
            slice?: number
            level?: number
        }>
        depth: {
            texture: Texture
            slice?: number
            level?: number
        }
        stencil?: {
            texture: Texture
            slice?: number
            level?: number
        }
    }
    export default class RenderPass extends PureResource {
        static SCREEN_RENDER_PASS: RenderPass
        constructor(options: IRenderPassOptions)
    }
}

declare module 'XrFrame/kanata/lib/frontend/resource/SkeletonBoneInverseModel' {
    import DataModel from 'XrFrame/kanata/lib/frontend/resource/DataModel'
    export default class SkeletonBoneInverseModel extends DataModel {
        boneNum: number
        setBoneInverseMatrix(matrices: Float32Array): void
    }
}

declare module 'XrFrame/kanata/lib/frontend/resource/Texture' {
    /**
     * Texture.ts
     *
     *         * @Date    : 9/4/2020, 2:35:42 PM
     */
    import {
        ETextureFormat,
        ETextureType,
        EWrapMode,
        EFilterMode,
        TTextureSource
    } from 'XrFrame/kanata/lib/backend'
    import PureResource from 'XrFrame/kanata/lib/frontend/shared/PureResource'
    /**
     * 纹理资源{@link Texture}的创建参数。
     */
    export interface ITextureOptions {
        /**
         * 纹理宽，如果`source`是`IImage`可以不传。
         */
        width?: number
        /**
         * 纹理高，如果`source`是`IImage`可以不传。
         */
        height?: number
        /**
         * @internal
         */
        isWriteOnly?: boolean
        /**
         * @internal
         */
        isRenderTarget?: boolean
        /**
         * @internal
         */
        canvas?: HTMLCanvasElement
        /**
         * 纹理数据源，如果是2D纹理，一般只能有一个元素。如果是`Buffer`类型数据，比如压缩纹理，则需要和`offsets`配合使用，一般用于`mipmaps`的场合。
         * 如果是立方体纹理，则有六个元素。
         */
        source?: TTextureSource[]
        /**
         * 当`source`为`Buffer`纹理并且拥有`mipmaps`之类的时，标记如何切割数据。
         * 规则是: off1, size1, off2, size2......
         */
        offsets?: Uint32Array
        /**
         * 纹理类型。
         */
        type?: ETextureType
        /**
         * 纹理有多少切片，比如立方体纹理就为`6`。
         */
        slices?: number
        /**
         * 纹理有多少级`mipmap`。
         */
        mips?: number
        /**
         * 纹理的像素格式。
         */
        pixelFormat?: ETextureFormat
        minFilter?: EFilterMode
        magFilter?: EFilterMode
        /**
         * 是否要自动生成`mipmaps`，仅对非压缩纹理有效。
         */
        generateMipmaps?: boolean
        wrapU?: EWrapMode
        wrapV?: EWrapMode
        wrapW?: EWrapMode
        /**
         * 各向异性等级。
         */
        anisoLevel?: number
        /**
         * @internal
         */
        sampleCount?: number
    }
    /**
     * 纹理资源。
     */
    export default class Texture extends PureResource {
        get type(): ETextureType
        get width(): number
        get height(): number
        get slice(): number
        get mips(): number
        get pixelFormat(): ETextureFormat
        get wrapU(): EWrapMode
        set wrapU(value: EWrapMode)
        get wrapV(): EWrapMode
        set wrapV(value: EWrapMode)
        get wrapW(): EWrapMode
        set wrapW(value: EWrapMode)
        get magFilter(): EFilterMode
        set magFilter(value: EFilterMode)
        get minFilter(): EFilterMode
        set minFilter(value: EFilterMode)
        get anisoLevel(): number
        set anisoLevel(value: number)
        get sampleCount(): number
        set sampleCount(value: number)
        get generateMipmaps(): boolean
        set generateMipmaps(value: boolean)
        get isRenderTarget(): boolean
        set isRenderTarget(value: boolean)
        constructor(options: ITextureOptions)
        /**
         * 在创建了纹理后，可以用此方法来更新。
         */
        update(options: {
            /**
             * `mipmap`等级。
             */
            level?: number
            /**
             * 切片。
             */
            slice?: number
            /**
             * x向偏移。
             */
            xoffset?: number
            /**
             * x向偏移。
             */
            yoffset?: number
            /**
             * @internal。
             */
            zoffset?: number
            /**
             * 宽，相对于x偏移。
             */
            width?: number
            /**
             * 高，相对于y偏移。
             */
            height?: number
            /**
             * 数据。
             */
            buffer: TTextureSource
        }): void
        showDebugInfo(): string
    }
}

declare module 'XrFrame/kanata/lib/frontend/resource/UniformBlock' {
    /**
     * UniformBlock.ts
     *
     *         * @Date    : 9/4/2020, 2:34:36 PM
     */
    import { IHandle } from 'XrFrame/kanata/lib/backend'
    import UniformDescriptor from 'XrFrame/kanata/lib/frontend/resource/UniformDescriptor'
    import Texture from 'XrFrame/kanata/lib/frontend/resource/Texture'
    import PureResource from 'XrFrame/kanata/lib/frontend/shared/PureResource'
    /**
     * 存储Uniform的一个区块。
     */
    export default class UniformBlock extends PureResource {
        /**
         * @internal
         */
        static CREATE_FAKE(descriptor: UniformDescriptor): FakeUniformBlock
        /**
         * @internal
         */
        /**
         * 描述符。
         */
        get descriptor(): UniformDescriptor
        /**
         * @internal
         */
        get textures(): {
            [name: string]: Texture
        }
        /**
         * @param descriptor 描述符。
         */
        constructor(descriptor: UniformDescriptor)
        protected _createNativeObj(descriptor: UniformDescriptor): IHandle
        /**
         * 是否包含某个成员uniform。
         */
        hasKey(key: string): boolean
        /**
         * 设置某个成员uniform。
         */
        setUniform(
            key: string,
            value: ArrayLike<number> | Texture | number
        ): boolean
        /**
         * 获取某个成员uniform。
         * 如果是返回`number`，则是纹理的id。
         */
        getUniform(key: string): Float32Array | number
        /**
         * 获取某个成员uniform的texture实例。
         */
        getTexture(key: string): Texture
        /**
         * @internal
         */
        /**
         * @internal
         */
        setAllData(data: Float32Array): void
        /**
         * 科隆某个uniform。
         */
        clone(): UniformBlock
        /**
         * 复制某个uniform。
         */
        copy(ub: UniformBlock): void
        showDebugInfo(): string
    }
    class FakeUniformBlock extends UniformBlock {
        protected _createNativeObj(descriptor: UniformDescriptor): {
            id: number
            data: ArrayBuffer
        }
    }
    export {}
}

declare module 'XrFrame/kanata/lib/frontend/resource/UniformDescriptor' {
    /**
     * UniformDescriptor.ts
     *
     *         * @Date    : 9/4/2020, 2:34:50 PM
     */
    import {
        EUniformType,
        IUniformDescriptorOptions
    } from 'XrFrame/kanata/lib/backend'
    import PureResource from 'XrFrame/kanata/lib/frontend/shared/PureResource'
    /**
     * UniformBlock描述符。
     */
    export default class UniformDescriptor extends PureResource {
        /**
         * @internal
         */
        get layout(): {
            [key: string]: [
                EUniformType,
                number,
                number,
                number,
                EUniformType,
                boolean
            ]
        }
        /**
         * 以Float计的长度。
         */
        get size(): number
        constructor(options: IUniformDescriptorOptions)
        /**
         * @internal
         */
        hasKey(key: string): boolean
        /**
         * @internal
         */
        setUniform(
            key: string,
            value: ArrayLike<number> | number,
            f32: Float32Array,
            u32: Uint32Array
        ): void
        /**
         * @internal
         */
        getUniform(
            key: string,
            f32: Float32Array,
            u32: Uint32Array
        ): Float32Array | number
        /**
         * @internal
         */
    }
}

declare module 'XrFrame/kanata/lib/frontend/resource/IndexBuffer' {
    import PureResource from 'XrFrame/kanata/lib/frontend/shared/PureResource'
    export default class IndexBuffer extends PureResource {
        get byteSize(): number
        constructor(buffer: ArrayBuffer | ArrayBufferView, is32bits?: boolean)
        update(buffer: ArrayBuffer | ArrayBufferView, offset: number): void
    }
}

declare module 'XrFrame/kanata/lib/frontend/resource/IndexData' {
    import PureResource from 'XrFrame/kanata/lib/frontend/shared/PureResource'
    export default class IndexData extends PureResource {
        get data(): ArrayBuffer
        constructor(size: number)
    }
}

declare module 'XrFrame/kanata/lib/frontend/resource/VertexBuffer' {
    import VertexLayout from 'XrFrame/kanata/lib/frontend/resource/VertexLayout'
    import PureResource from 'XrFrame/kanata/lib/frontend/shared/PureResource'
    /**
     * 顶点数据。
     */
    export default class VertexBuffer extends PureResource {
        get byteSize(): number
        get layout(): VertexLayout
        constructor(buffer: ArrayBuffer | ArrayBufferView, layout: VertexLayout)
        update(buffer: ArrayBuffer | ArrayBufferView, offset: number): void
    }
}

declare module 'XrFrame/kanata/lib/frontend/resource/VertexData' {
    /**
     * VertexData.ts
     *
     *         * @Date    : 9/11/2020, 4:43:52 PM
     */
    import VertexDataDescriptor from 'XrFrame/kanata/lib/frontend/resource/VertexDataDescriptor'
    import PureResource from 'XrFrame/kanata/lib/frontend/shared/PureResource'
    import VertexLayout from 'XrFrame/kanata/lib/frontend/resource/VertexLayout'
    /**
     * 用于合批的顶点数据。
     */
    export default class VertexData extends PureResource {
        get layout(): VertexLayout
        get data(): ArrayBuffer
        constructor(
            layout: VertexLayout,
            size: number,
            batchDesc: VertexDataDescriptor
        )
    }
}

declare module 'XrFrame/kanata/lib/frontend/resource/VertexLayout' {
    /**
     * VertexLayout.ts
     *
     *         * @Date    : 9/4/2020, 5:01:51 PM
     */
    import {
        IVertexLayoutOptions,
        EVertexLayoutUsage
    } from 'XrFrame/kanata/lib/backend'
    import PureResource from 'XrFrame/kanata/lib/frontend/shared/PureResource'
    /**
     * 顶点布局描述。
     */
    export default class VertexLayout extends PureResource {
        /**
         * 顶点数据单位步长。
         */
        get stride(): number
        constructor(options: IVertexLayoutOptions)
        /**
         * 获取某个属性的配置。
         */
        getConfigByName(name: string): {
            name: string
            format: import('XrFrame/kanata/lib/backend').EVertexFormat
            offset: number
            usage: EVertexLayoutUsage
        }
        /**
         * 获取某个用途的属性的配置。
         */
        getConfigByUsage(usage: EVertexLayoutUsage): {
            name: string
            format: import('XrFrame/kanata/lib/backend').EVertexFormat
            offset: number
            usage: EVertexLayoutUsage
        }
    }
}

declare module 'XrFrame/kanata/lib/frontend/resource/VertexDataDescriptor' {
    /**
     * VertexDataDescriptor.ts
     *
     *         * @Date    : 4/28/2021, 4:38:37 PM
     */
    import { IVertexDataDescriptorOptions } from 'XrFrame/kanata/lib/backend'
    import PureResource from 'XrFrame/kanata/lib/frontend/shared/PureResource'
    /**
     * 用于合批的顶点数据的描述符。
     */
    export default class VertexDataDescriptor extends PureResource {
        constructor(options: IVertexDataDescriptorOptions)
    }
}

declare module 'XrFrame/kanata/lib/frontend/resource/View' {
    /**
     * View.ts
     *
     *         * @Date    : 9/4/2020, 6:43:18 PM
     */
    import { IRect, IViewAction } from 'XrFrame/kanata/lib/backend'
    import PureResource from 'XrFrame/kanata/lib/frontend/shared/PureResource'
    /**
     * 视图，用于控制清屏、视图区域等配置。
     */
    export default class View extends PureResource {
        constructor(options: {
            passAction: IViewAction
            viewport: IRect
            scissor: IRect
        })
    }
}

declare module 'XrFrame/kanata/lib/frontend/resource/ScalableList' {
    import PureResource from 'XrFrame/kanata/lib/frontend/shared/PureResource'
    export const SL_MAP: Set<ScalableList>
    export function CHECK_SLS_RESIZE(): void
    export function CLEAR_SLS(): void
    /**
     * 可扩容列表，用于存储Mesh的剔除结果以及绘制数据的id。
     */
    export default class ScalableList extends PureResource {
        /**
         * 当前全部可用的大小。
         */
        get size(): number
        /**
         * 存储的id集合。
         */
        get dataView(): Uint32Array
        /**
         * 当前已用的大小，一般不需要自己设置。
         */
        get usedSize(): number
        set usedSize(value: number)
        constructor(initSize: number)
        /**
         * 扩容，将会扩大两倍，一般不需要自己调用。
         *
         * @param deprecatedSize will always be current size, don't use it!
         */
        enlarge(deprecatedSize?: number): void
        /**
         * 初始化到准备`add`的阶段。
         */
        begin(): void
        /**
         * 添加一个数据。
         *
         * @param deprecatedEnlargeSize will always be current size, don't use it!
         */
        add(id: number, deprecatedEnlargeSize?: number): void
        /**
         * 结束此次所有`add`的流程。
         */
        end(): void
        /**
         * 清空整个列表。
         */
        reset(): void
    }
}

declare module 'XrFrame/kanata/lib/frontend/shared/crossContext' {
    /**
     * 跨域信息通道，用于主域和子域之间的通信。
     */
    class CrossContext {
        constructor()
        postMessage(data: any): void
        onMessage(callback: (data: any) => void): void
        flush(): void
    }
    let crossContext: CrossContext
    export default crossContext
}

declare module 'XrFrame/components/particle/gradient' {
    import Vector3 from 'XrFrame/math/vector3'
    import Vector4 from 'XrFrame/math/vector4'
    export class ColorGradient {
        gradient: number
        color: Vector4
        color2: Vector4
        constructor(gradient: any, color: any, color2: any)
        /**
         * 获取具体颜色属性值
         * @param {Vector4} 用于存储结果的临时变量
         */
        getColor(colorTemp: Vector4): void
    }
    export class Color3Gradient {
        gradient: number
        color: Vector3
        constructor(gradient: any, color: any)
    }
    export class FactorGradient {
        gradient: number
        factor: number
        factor2: number
        constructor(gradient: any, factor: any, factor2: any)
        /**
         * 获取具体属性值
         * @return {number} 插值后的属性大小
         */
        getFactor(): number
    }
    export class BasicGradientMethod {
        /**
         * 从获取具体时刻的属性大小
         * @param {number} ratio 粒子所处生命周期的阶段
         * @param {Array} gradients 存储不同时刻指定属性变化的数组
         * @param {Callback} updateFunc 回调函数
         */
        static GetCurrentGradient(
            ratio: any,
            gradients: any,
            updateFunc: any
        ): void
    }
}

declare module 'XrFrame/components/emitter/BoxShapeEmitter' {
    import Vector3 from 'XrFrame/math/vector3'
    import { BasicShapeEmitter } from 'XrFrame/components/emitter/BasicShapeEmitter'
    export default class BoxShapeEmitter extends BasicShapeEmitter {
        direction: Vector3
        direction2: Vector3
        minEmitBox: Vector3
        maxEmitBox: Vector3
        constructor()
        startDirection(worldMatrix: any, direction: any): void
        startPosition(worldMatrix: any, position: Vector3): void
    }
}

declare module 'XrFrame/components/emitter/PointShapeEmitter' {
    import Vector3 from 'XrFrame/math/vector3'
    import { BasicShapeEmitter } from 'XrFrame/components/emitter/BasicShapeEmitter'
    export default class PointShapeEmitter extends BasicShapeEmitter {
        /**
         * 粒子运动方向左区间。
         */
        direction: Vector3
        /**
         * 粒子运动方向右区间。
         */
        direction2: Vector3
        constructor()
        startDirection(worldMatrix: any, direction: any): void
        startPosition(worldMatrix: any, position: Vector3): void
    }
}

declare module 'XrFrame/components/emitter/DrawShapeEmitter' {
    import Vector3 from 'XrFrame/math/vector3'
    import ParticleInstance from 'XrFrame/components/particle/ParticleInstance'
    import { BasicShapeEmitter } from 'XrFrame/components/emitter/BasicShapeEmitter'
    export default class DrawShapeEmitter extends BasicShapeEmitter {
        direction: Vector3
        constructor()
        setContent(content: any, step?: number): void
        translateBase64ToArrayBuffer(base64: any): ArrayBufferLike
        startDirection(worldMatrix: any, direction: any): void
        startPosition(worldMatrix: any, position: Vector3): void
        processInstance(instance: ParticleInstance, deltaTime: number): void
        lerpNumberArrayToVector(
            vector: any,
            numberArray1: any,
            numberArray2: any,
            step: any,
            length?: number
        ): void
    }
}

declare module 'XrFrame/components/emitter/SphereShapeEmitter' {
    import Vector3 from 'XrFrame/math/vector3'
    import { BasicShapeEmitter } from 'XrFrame/components/emitter/BasicShapeEmitter'
    import Matrix4 from 'XrFrame/math/matrix4'
    export default class SphereShapeEmitter extends BasicShapeEmitter {
        /**
         * 球形半径
         */
        radius: number
        /**
         * 球形区域覆盖范围[0-1]
         */
        radiusRange: number
        /**
         * 粒子在球形内生成的角度区间[0-360]
         */
        arc: number
        /**
         * 粒子运动方向偏离程度[0-1]
         */
        randomizeDirection: number
        constructor()
        startDirection(
            worldMatrix: Matrix4,
            direction: Vector3,
            position: Vector3
        ): void
        startPosition(worldMatrix: Matrix4, position: Vector3): void
    }
}

declare module 'XrFrame/components/emitter/ConeShapeEmitter' {
    import Vector3 from 'XrFrame/math/vector3'
    import { BasicShapeEmitter } from 'XrFrame/components/emitter/BasicShapeEmitter'
    export default class ConeShapeEmitter extends BasicShapeEmitter {
        /**
         * [0-1]
         */
        radiusRange: number
        heightRange: number
        /**
         * [0-360]
         */
        arc: number
        /**
         * randomize the particle direction [0-1]
         */
        randomizeDirection: number
        get radius(): number
        set radius(value: number)
        get angle(): number
        set angle(value: number)
        updateHeight(): void
        constructor()
        startDirection(
            worldMatrix: any,
            direction: any,
            position: Vector3
        ): void
        startPosition(worldMatrix: any, position: Vector3): void
    }
}

declare module 'XrFrame/components/emitter/CircleShapeEmitter' {
    import Vector3 from 'XrFrame/math/vector3'
    import { BasicShapeEmitter } from 'XrFrame/components/emitter/BasicShapeEmitter'
    import Matrix4 from 'XrFrame/math/matrix4'
    export default class CircleShapeEmitter extends BasicShapeEmitter {
        radius: number
        radiusRange: number
        direction: Vector3
        direction2: Vector3
        arc: number
        angle: number
        constructor()
        startDirection(
            worldMatrix: Matrix4,
            direction: Vector3,
            position: Vector3
        ): void
        startPosition(worldMatrix: any, position: Vector3): void
    }
}

declare module 'XrFrame/render-graph/RGNode' {
    /**
     * RGNode.ts
     *
     *         * @Date    : 1/13/2021, 8:29:55 PM
     */
    import { Kanata } from 'XrFrame/ext'
    import Camera from 'XrFrame/components/Camera'
    import { IRenderTarget } from 'XrFrame/assets/RenderTexture'
    type RenderGraph = import('XrFrame/render-graph/RenderGraph').default
    type RenderSystem = import('XrFrame/systems/RenderSystem').default
    type Scene = import('XrFrame/core/Scene').default
    export type TRGNodeAny = RGNode<any, any, any>
    /**
     * RGNode支持传输的数据类型。
     * 可扩展。
     *
     * @category Render
     */
    export interface IRGData {
        /**
         * 空数据类型。
         */
        None: void
        /**
         * 相机类型。
         */
        Camera: Camera
        /**
         * 渲染目标类型。
         */
        RenderTarget: IRenderTarget
        /**
         * Mesh列表，一般作为剔除节点的输出，作为渲染节点的输入。
         */
        MeshList: Kanata.ScalableList
    }
    /**
     * RGNode支持的节点类型。
     */
    export enum ERGNodeType {
        Camera = 'Camera',
        Clear = 'Clear',
        Cull = 'Cull',
        Render = 'Render',
        Script = 'Script'
    }
    /**
     * 渲染节点基类。
     */
    export default abstract class RGNode<
        TInputs extends {
            [key: string]: keyof IRGData
        },
        TOutput extends keyof IRGData,
        IOptions
    > {
        protected _parent: RenderGraph
        protected _id: number
        protected _name: string
        protected _options: IOptions
        /**
         * 节点类型。
         *
         * @internal
         */
        type: ERGNodeType
        /**
         * 节点输入的数据类型。
         */
        abstract inputTypes: TInputs
        /**
         * 节点输出的数据类型。
         */
        abstract outputType: TOutput
        protected _output?: IRGData[TOutput]
        protected _inputs: {
            [key: string]: TRGNodeAny
        }
        protected _outputs: {
            [id: number]: string
        }
        /**
         * 节点的初始化配置参数。
         */
        get options(): IOptions
        /**
         * 节点名字。
         */
        get name(): string
        /**
         * 节点id。
         */
        get id(): number
        /**
         * 获取当前游戏实例。
         */
        get scene(): Scene
        /**
         * 获取当前节点输出。
         */
        get output(): IRGData[TOutput]
        /**
         * 不要直接调用，请使用`renderGraph.createNode`方法。
         */
        constructor(
            _parent: RenderGraph,
            _id: number,
            _name: string,
            _options: IOptions
        )
        /**
         * 节点初始化后的回调。
         */
        onInit(options: IOptions): void
        /**
         * 获取某个节点的输入。
         */
        getInput<TKey extends keyof TInputs>(key: TKey): IRGData[TInputs[TKey]]
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * @internal
         */
        /**
         * 重置节点状态，清空输入，一般用于可缓存的节点优化。
         */
        reset(): void
        /**
         * 节点在真正被第一次使用时的回调。
         */
        onActive(context: RenderSystem, options: IOptions): void
        /**
         * 节点在每帧执行时的回调。
         */
        onExecute(context: RenderSystem, options: IOptions): void
        /**
         * 节点在被图中移除时的回调。
         */
        onDisable(context: RenderSystem, options: IOptions): void
    }
    export {}
}

declare module 'XrFrame/physics/RaycastHit' {
    import { Scene } from 'XrFrame/elements'
    import Vector3 from 'XrFrame/math/vector3'
    import Shape from 'XrFrame/components/physics/Shape'
    export default class RaycastHit {
        constructor(scene: Scene, nativeComp?: phys3D.RaycastHit)
        /**
         * native层真正的raycastHit对象，业务侧无需关心
         */
        get nativeRaycastHit(): phys3D.RaycastHit
        /**
         * 被射线射中的collider所附的Rigidbody，如果collider没有附着在一个Rigidbody上，则为null
         */
        get rigidbody(): any
        /**
         * 被射线射中的collider
         */
        get collider(): Shape
        /**
         * 从光线的原点到碰撞点的距离
         */
        get distance(): number
        set distance(v: number)
        /**
         * 射线锁碰到的表面的法线
         */
        get normal(): Vector3
        set normal(v: Vector3)
        /**
         * 在世界空间中，射线碰到collider的碰撞点
         */
        get point(): Vector3
        set point(v: Vector3)
    }
}

declare module 'XrFrame/loader/glTF/animations/GLTFAnimationNode' {
    import { Kanata } from 'XrFrame/ext'
    import { GLTFAccessorsLoaded } from 'XrFrame/loader/glTF/buffers/GLTFAccessorsNode'
    import { GLTFBaseNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import { GLTFNodesLoaded } from 'XrFrame/loader/glTF/scenes/GLTFNodesNode'
    import { GLTF } from 'XrFrame/loader/glTF/utils/types'
    import {
        GLTFChannelsLoaded,
        GLTFChannelsNodeRaw
    } from 'XrFrame/loader/glTF/animations/channels/GLTFChannelsNode'
    import { GLTFSamplersNodeRaw } from 'XrFrame/loader/glTF/animations/samplers/GLTFSamplersNode'
    /**
     * 二进制格式
     * | contentoffset | fps(float) | totalFrame | totalSampleGroup |
     * | Array<PuppetAnimationSampleGroup> |
     *
     * @see PuppetAnimationSampleGroup at GLTFChannelNode.ts
     */
    export type PuppetAnimationClipModel = ArrayBuffer | GLTF.BufferView
    export interface GLTFAnimationNodeRaw {
        channels: GLTFChannelsNodeRaw
        samplers: GLTFSamplersNodeRaw
        name?: string
    }
    export interface GLTFAnimationLoaded {
        clip: Kanata.AnimationClipModel
        channels: GLTFChannelsLoaded
        frameCount: number
        name?: string
    }
    export default class GLTFAnimationNode extends GLTFBaseNode {
        get nodeName(): string
        readonly raw: GLTFAnimationNodeRaw
        resource: GLTFAnimationLoaded | null
        build(): void
        preload(
            prerequisites: [
                accessors: GLTFAccessorsLoaded,
                nodes: GLTFNodesLoaded
            ]
        ): Promise<GLTFAnimationLoaded>
        getLoadedResource(): GLTFAnimationLoaded
    }
}

declare module 'XrFrame/loader/glTF/buffers/GLTFAccessorNode' {
    import { GLTF } from 'XrFrame/loader/glTF/utils/types'
    import { GLTFBaseNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import { GLTFBufferViewLoaded } from 'XrFrame/loader/glTF/buffers/GLTFBufferViewNode'
    import { GLTFBufferViewsLoaded } from 'XrFrame/loader/glTF/buffers/GLTFBufferViewsNode'
    export enum EnumGLTFAccessorComponentType {
        BYTE = 5120,
        UNSIGNED_BYTE = 5121,
        SHORT = 5122,
        UNSIGNED_SHORT = 5123,
        UNSIGNED_INT = 5125,
        FLOAT = 5126
    }
    export const GLTFAccessorComponentTypeToViewClass: {
        5120: Int8ArrayConstructor
        5121: Uint8ArrayConstructor
        5122: Int16ArrayConstructor
        5123: Uint16ArrayConstructor
        5125: Uint32ArrayConstructor
        5126: Float32ArrayConstructor
    }
    export const GLTFAccessorTypeToNumberOfElements: {
        SCALAR: number
        VEC2: number
        VEC3: number
        VEC4: number
        MAT2: number
        MAT3: number
        MAT4: number
    }
    export interface GLTFAccessorNodeRaw {
        bufferView?: number
        byteOffset?: number
        componentType: number
        count: number
        min?: number[]
        max?: number[]
        type: string
        normalized?: boolean
        sparse?: boolean
        name?: string
    }
    /**
     * 以FloatVec3为例：
     * 一个component指一个float，
     * 一个element指三个float。
     */
    export interface GLTFAccessorLoaded {
        bufferView: GLTFBufferViewLoaded
        bufferViewIndex: number
        view: GLTF.BufferView
        elementLength: number
        bytesPerComponent: number
        count: number
        stride: number
        byteStride: number
        componentType: EnumGLTFAccessorComponentType
        max?: number[]
        min?: number[]
        compact: boolean
        getCompAt(element: number, comp: number): any
    }
    export default class GLTFAccessorNode extends GLTFBaseNode {
        get nodeName(): string
        readonly raw: GLTFAccessorNodeRaw
        build(): void
        preload(
            prerequisites: [GLTFBufferViewsLoaded]
        ): Promise<GLTFAccessorLoaded>
        getLoadedResource(): GLTFAccessorLoaded
    }
}

declare module 'XrFrame/loader/glTF/buffers/GLTFBufferNode' {
    import { GLTFBaseNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    export interface GLTFBufferNodeRaw {
        uri?: string
        byteLength: number
        name?: string
    }
    export type GLTFBufferLoaded = ArrayBuffer
    export default class GLTFBufferNode extends GLTFBaseNode {
        get nodeName(): string
        readonly raw: GLTFBufferNodeRaw
        build(): void
        preload(): Promise<GLTFBufferLoaded>
        getLoadedResource(): GLTFBufferLoaded
    }
}

declare module 'XrFrame/loader/glTF/buffers/GLTFBufferViewNode' {
    import { GLTFBaseNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import { GLTFBufferLoaded } from 'XrFrame/loader/glTF/buffers/GLTFBufferNode'
    export interface GLTFBufferViewNodeRaw {
        buffer: number
        byteLength: number
        byteOffset?: number
        byteStride?: number
        target?: EnumGLTFBufferViewTarget
        name?: string
    }
    export interface GLTFBufferViewLoaded {
        data: ArrayBuffer
        byteOffset: number
        byteStride: number
        byteLength: number
        target: EnumGLTFBufferViewTarget
        getSlicedData(): ArrayBuffer
        getUint8View(): Uint8Array
        _sliced: ArrayBuffer
    }
    export enum EnumGLTFBufferViewTarget {
        ARRAY_BUFFER = 34962,
        ELEMENT_ARRAY_BUFFER = 34963
    }
    export default class GLTFBufferViewNode extends GLTFBaseNode {
        get nodeName(): string
        readonly raw: GLTFBufferViewNodeRaw
        build(): void
        preload(
            prerequisites: [GLTFBufferLoaded]
        ): Promise<GLTFBufferViewLoaded>
        getLoadedResource(): GLTFBufferViewLoaded
    }
}

declare module 'XrFrame/loader/glTF/geometry/GLTFMeshNode' {
    import { Kanata } from 'XrFrame/ext'
    import { GLTFAccessorsLoaded } from 'XrFrame/loader/glTF/buffers/GLTFAccessorsNode'
    import { GLTFBaseNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import { GLTFMaterialsLoaded } from 'XrFrame/loader/glTF/materials/GLTFMaterialsNode'
    import {
        GLTFPrimitivesLoaded,
        GLTFPrimitivesNodeRaw
    } from 'XrFrame/loader/glTF/geometry/primitives/GLTFPrimitivesNode'
    export interface GLTFMeshNodeRaw {
        primitives: GLTFPrimitivesNodeRaw
        weights?: number[]
        name?: string
    }
    export interface GLTFMeshLoaded {
        subMeshes: GLTFPrimitivesLoaded
        weights: number[]
        name?: string
    }
    export default class GLTFMeshNode extends GLTFBaseNode {
        get nodeName(): string
        readonly raw: GLTFMeshNodeRaw
        build(): void
        preload(
            prerequisites: [
                materials: GLTFMaterialsLoaded,
                accessors: GLTFAccessorsLoaded,
                vbMap: Map<string, [ArrayBuffer, Kanata.VertexLayout, object]>
            ]
        ): Promise<GLTFMeshLoaded>
        getLoadedResource(): GLTFMeshLoaded
    }
}

declare module 'XrFrame/loader/glTF/materials/GLTFMaterialNode' {
    import { GLTFBaseNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import GLTFTextureInfoNode, {
        GLTFTextureInfoNodeRaw
    } from 'XrFrame/loader/glTF/materials/texture/GLTFTextureInfoNode'
    import GLTFPBRMetallicRoughnessNode, {
        GLTFPBRMetallicRoughnessNodeRaw
    } from 'XrFrame/loader/glTF/materials/pbr/GLTFPBRMetallicRoughnessNode'
    import GLTFNormalTextureInfoNode, {
        GLTFNormalTextureInfoNodeRaw
    } from 'XrFrame/loader/glTF/materials/texture/GLTFNormalTextureInfoNode'
    import GLTFOcclusionTextureInfoNode, {
        GLTFOcclusionTextureInfoNodeRaw
    } from 'XrFrame/loader/glTF/materials/texture/GLTFOcclusionTextureInfoNode'
    import Material from 'XrFrame/assets/Material'
    import { IRenderStates } from 'XrFrame/assets/Effect'
    import { GLTFTexturesLoaded } from 'XrFrame/loader/glTF/textures/GLTFTexturesNode'
    export interface GLTFMaterialExtArgs {
        uniform: object
        renderStates: IRenderStates
        macros: object
    }
    export enum EnumGLTFMaterialAlphaMode {
        OPAQUE = 0,
        MASK = 1,
        BLEND = 2
    }
    export interface GLTFMaterialNodeRaw {
        name?: string
        pbrMetallicRoughness?: GLTFPBRMetallicRoughnessNodeRaw
        normalTexture?: GLTFNormalTextureInfoNodeRaw
        occlusionTexture?: GLTFOcclusionTextureInfoNodeRaw
        emissiveTexture?: GLTFTextureInfoNodeRaw
        emissiveFactor?: [number, number, number]
        alphaMode?: string
        alphaCutoff?: number
        doubleSided?: boolean
    }
    export type GLTFMaterialPrerequisites = [textrues: GLTFTexturesLoaded]
    export type GLTFMaterialLoaded = Material
    export default class GLTFMaterialNode extends GLTFBaseNode {
        get nodeName(): string
        readonly raw: GLTFMaterialNodeRaw
        resource: GLTFMaterialLoaded | null
        pbrMetallicRoughness: GLTFPBRMetallicRoughnessNode | undefined
        normalTexture: GLTFNormalTextureInfoNode | undefined
        occlusionTexture: GLTFOcclusionTextureInfoNode | undefined
        emissiveTexture: GLTFTextureInfoNode | undefined
        build(): void
        /**
         * @internal
         */
        preloadWithoutPBR(
            prerequisites: GLTFMaterialPrerequisites
        ): Promise<GLTFMaterialExtArgs>
        /**
         * 实际上不一定会走到这里，mesh没有material也是合法的，这时候会去取emptyMaterial。
         */
        preload(
            prerequisites: [textrues: GLTFTexturesLoaded]
        ): Promise<GLTFMaterialLoaded>
        getLoadedResource(): GLTFMaterialLoaded
    }
}

declare module 'XrFrame/loader/glTF/skins/GLTFSkinNode' {
    import { Kanata } from 'XrFrame/ext'
    import { GLTFAccessorsLoaded } from 'XrFrame/loader/glTF/buffers/GLTFAccessorsNode'
    import { GLTFBaseNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    export interface GLTFSkinNodeRaw {
        inverseBindMatrices?: number
        skeleton?: number
        joints: number[]
    }
    export interface GLTFSkinLoaded {
        inverseBindMatrices: Kanata.SkeletonBoneInverseModel
        skeleton?: number
        joints: number[]
    }
    export default class GLTFSkinNode extends GLTFBaseNode {
        get nodeName(): string
        readonly raw: GLTFSkinNodeRaw
        resource: GLTFSkinLoaded | null
        build(): void
        preload(
            prerequisites: [accessors: GLTFAccessorsLoaded]
        ): Promise<GLTFSkinLoaded>
        getLoadedResource(): GLTFSkinLoaded
    }
}

declare module 'XrFrame/loader/glTF/textures/GLTFImageNode' {
    import { Kanata } from 'XrFrame/ext'
    import { GLTFBufferViewsLoaded } from 'XrFrame/loader/glTF/buffers/GLTFBufferViewsNode'
    import { GLTFBaseNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    export interface GLTFImageNodeRaw {
        uri?: string
        mimeType?: string
        bufferView?: number
        name?: string
    }
    export interface GLTFImageLoaded {
        kanataImage?: Kanata.IImage
        type?: string
    }
    export default class GLTFImageNode extends GLTFBaseNode {
        get nodeName(): string
        readonly raw: GLTFImageNodeRaw
        build(): void
        preload(
            prerequisites: [bufferViews: GLTFBufferViewsLoaded]
        ): Promise<GLTFImageLoaded>
        getLoadedResource(): GLTFImageLoaded
    }
}

declare module 'XrFrame/loader/glTF/textures/GLTFSamplerNode' {
    import { GLTFBaseNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    export enum EnumGLTFSamplerFilter {
        NEAREST = 9728,
        LINEAR = 9729,
        NEAREST_MIPMAP_NEAREST = 9984,
        LINEAR_MIPMAP_NEAREST = 9985,
        NEAREST_MIPMAP_LINEAR = 9986,
        LINEAR_MIPMAP_LINEAR = 9987
    }
    export function NeedMipmap(sampler: EnumGLTFSamplerFilter): boolean
    export enum EnumGLTFSamplerWrap {
        CLAMP_TO_EDGE = 33071,
        MIRRORED_REPEAT = 33648,
        REPEAT = 10497
    }
    export interface GLTFSamplerNodeRaw {
        magFilter?: number
        minFilter?: number
        wrapS?: number
        wrapT?: number
        name?: string
    }
    export interface GLTFSamplerLoaded {
        magFilter: EnumGLTFSamplerFilter
        minFilter: EnumGLTFSamplerFilter
        wrapS: EnumGLTFSamplerWrap
        wrapT: EnumGLTFSamplerWrap
    }
    export default class GLTFSamplerNode extends GLTFBaseNode {
        get nodeName(): string
        readonly raw: GLTFSamplerNodeRaw
        build(): void
        preload(): Promise<GLTFSamplerLoaded>
        getLoadedResource(): GLTFSamplerLoaded
    }
}

declare module 'XrFrame/loader/glTF/textures/GLTFTextureNode' {
    import { GLTFBaseNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import { GLTFImagesLoaded } from 'XrFrame/loader/glTF/textures/GLTFImagesNode'
    import { GLTFSamplersLoaded } from 'XrFrame/loader/glTF/textures/GLTFSamplersNode'
    import { Kanata } from 'XrFrame/ext'
    export interface GLTFTextureNodeRaw {
        sampler?: number
        source?: number
        name?: string
    }
    export type GLTFTextureLoaded = Kanata.Texture
    export default class GLTFTextureNode extends GLTFBaseNode {
        get nodeName(): string
        readonly raw: GLTFTextureNodeRaw
        build(): void
        preload(
            prerequisites: [
                images: GLTFImagesLoaded,
                samplers: GLTFSamplersLoaded
            ]
        ): Promise<GLTFTextureLoaded>
        getLoadedResource(): GLTFTextureLoaded
    }
}

declare module 'XrFrame/loader/glTF/utils/types' {
    import { ITransformData } from 'XrFrame/components'
    import { Kanata } from 'XrFrame/ext'
    import Quaternion from 'XrFrame/math/quaternion'
    import Vector3, { Vector3ReadOnly } from 'XrFrame/math/vector3'
    export namespace GLTF {
        type BufferView =
            | Int8Array
            | Uint8Array
            | Uint16Array
            | Uint32Array
            | Float32Array
        type IndexBufferView = Uint16Array | Uint32Array | Uint8Array
        class BoundingBox {
            min: Vector3
            max: Vector3
            adoptMin: (newMin: Vector3) => void
            adoptMax: (newMax: Vector3) => void
        }
        interface BoundingBoxReadOnly {
            min: Vector3ReadOnly
            max: Vector3ReadOnly
        }
        namespace BoundingBox {
            function createZero(): BoundingBox
            function createInfinite(): BoundingBox
        }
        interface VertexLayoutDesc extends Kanata.IVertexLayoutOptions {
            stride: number
        }
        interface VertexProperties {
            buffer: Float32Array
            layoutDesc: VertexLayoutDesc
            layout: Kanata.VertexLayout
            macros: object
            boundingBox: BoundingBox
            /**
             * 是否需要自行生成normal和tangent的顶点数据。
             */
            lackNormal: boolean
            lackTangent: boolean
            /**
             * 如果需要生成的话，生成在layoutDesc的哪个attribute里。
             */
            normalSlot: number
            tangentSlot: number
        }
        interface Transform extends ITransformData {
            /**
             * 同时有quat和rotation的情况下，quat优先；
             * 目前只会填写quat，不会填写rotation。
             */
            quat?: Quaternion
        }
    }
}

declare module 'XrFrame/kanata/lib/backend' {
    /**
     * index.ts
     *
     *       * @Date    : 9/3/2020, 8:45:18 PM
     */
    export * from 'XrFrame/kanata/lib/backend/interface'
    import { IImage } from 'XrFrame/kanata/lib/backend/interface'
    import { IWorker } from 'XrFrame/kanata/lib/backend/interface/IWorker'
    export interface IBackend {
        IS_VALID: () => boolean
        GET_MAIN_CANVAS(): HTMLCanvasElement
        worker: IWorker
        Image: {
            new (): IImage
            IS(obj: any): obj is IImage
        }
        Phys3D: any
    }
    const backend: IBackend
    export default backend
}

declare module 'XrFrame/kanata/lib/frontend/shared/NativeObject' {
    /**
     * NativeObject.ts
     *
     *       * @Date    : 9/3/2020, 9:17:03 PM
     */
    import { IHandle } from 'XrFrame/kanata/lib/backend'
    export default class NativeObject {
        _bufferName: string
        _byteOffset: number
        _bufferLength: number
        id: number
        _buffer: ArrayBuffer
        _f32view: Float32Array
        _u32view: Uint32Array
        protected _handle: IHandle
        protected _init(info: IHandle): void
        protected _fastInit(info: IHandle): void
        protected _initU32View(): void
        protected _initPropertyView(
            offset: number,
            length: number
        ): Float32Array
        setRawBuffer(data: Float32Array): void
        destroy(): void
    }
}

declare module 'XrFrame/kanata/lib/frontend/pool/PoolObject' {
    import Pool from 'XrFrame/kanata/lib/frontend/pool/Pool'
    export interface INativePools {
        [poolId: number]: Pool
    }
    export default class PoolObject {
        protected _nativePool: Pool
        protected _nativeId: number
        protected _poolId: number
        protected _poolIndex: number
        protected _using: boolean
        entityOffset: number
        get float32View(): Float32Array
        get uint32View(): Uint32Array
        get id(): number
        get poolId(): number
        get poolIndex(): number
        get poll(): any
        get isUsing(): boolean
        set isUsing(value: boolean)
        protected _init(nativeObjId: number, nativePools: INativePools): void
        setRawBuffer(data: Float32Array): void
    }
}

declare module 'XrFrame/kanata/lib/frontend/pool/PoolManager' {
    /**
     * PoolManager.ts
     *
     *       * @Date    : 9/3/2020, 9:19:34 PM
     */
    import { IHandle } from 'XrFrame/kanata/lib/backend'
    import PoolObject, {
        INativePools
    } from 'XrFrame/kanata/lib/frontend/pool/PoolObject'
    export default class PoolManager {
        pools: INativePools
        constructor(
            template: ArrayBuffer,
            templateView: Float32Array,
            allocateFunc: (size: number) => IHandle,
            extendedMemSize?: number
        )
        allocateOne(): number
        dispose(obj: PoolObject): void
    }
}

declare module 'XrFrame/kanata/lib/frontend/shared/PureResource' {
    /**
     * PureResource.ts
     *
     *       * @Date    : 9/8/2020, 9:04:32 PM
     */
    import { IHandle } from 'XrFrame/kanata/lib/backend'
    export default class PureResource {
        id: number
        __handle: IHandle
        protected get _handle(): IHandle
        protected set _handle(value: IHandle)
        destroy(): void
    }
}

declare module 'XrFrame/kanata/lib/backend/native/worker' {
    import {
        IHandle,
        ETextureType,
        ETextureFormat,
        IRect,
        EMeshRenderType,
        INativeMap,
        ILongIntNativeMap,
        IGlyphInfo,
        IRenderEnv
    } from 'XrFrame/kanata/lib/backend/interface'
    export interface INativeWorker {
        createVertexLayout(options: string): IHandle
        createVertexDataDescriptor(options: string): IHandle
        createVertexBuffer(
            buffer: ArrayBuffer | ArrayBufferView,
            layout: number
        ): IHandle
        updateVertexBuffer(
            bufferId: number,
            buffer: ArrayBuffer | ArrayBufferView,
            offset: number
        ): void
        createIndexBuffer(
            buffer: ArrayBuffer | ArrayBufferView,
            is32bits?: boolean
        ): IHandle
        updateIndexBuffer(
            bufferId: number,
            buffer: ArrayBuffer | ArrayBufferView,
            offset: number
        ): void
        createVertexData(
            layout: number,
            size: number,
            batchDesc: number
        ): IHandle
        createIndexData(size: number): IHandle
        createTexture(
            type: ETextureType,
            width: number,
            height: number,
            slice: number,
            mips: number,
            format: ETextureFormat,
            flags: number,
            buffer: Array<ArrayBuffer | ArrayBufferView>,
            offsets: Uint32Array
        ): IHandle
        createTexture(canvas: HTMLCanvasElement): IHandle
        updateTexture(
            id: number,
            level: number,
            slice: number,
            xoffset: number,
            yoffset: number,
            zoffset: number,
            width: number,
            height: number,
            buffer: ArrayBuffer | ArrayBufferView
        ): void
        updateTextureFlags(textureId: number, flags: number): void
        createShader(vs: string, fs: string): IHandle
        createUniformBlockDescriptor(descriptor: string): IHandle
        createUniformBlock(descriptor: number): IHandle
        createEffect(
            name: string,
            passCount: number,
            keyIndexMap: string,
            passes: string,
            shaders: string[],
            variants: string,
            flags: number
        ): IHandle & {
            warmUp(): void
        }
        createMaterial(macros: string): IHandle
        changeMaterialMacros(
            material: number,
            macros: string,
            reset?: boolean
        ): void
        createScalableList(
            initSize: number,
            onBackendEnlarge: () => void
        ): IHandle & {
            enlarge(size: number): void
        }
    }
    export interface INativeWorker {
        createView(view: string): IHandle
        updateViewRect(view: number, rect: IRect): void
        updateViewScissor(view: number, rect: IRect): void
    }
    export interface INativeWorker {
        createRenderPass(descriptor: string): IHandle
    }
    export interface INativeWorker {
        createNodePool(count: number, is3d: boolean): IHandle
        createNodeTree(
            length: number,
            ids: ArrayBuffer,
            buffer: ArrayBuffer,
            calculateWordMatrix: boolean,
            is3d?: boolean
        ): boolean
    }
    export namespace INativeWorker {
        interface IAnimationClipBinding extends IHandle {
            id: number
            rebind(
                buffer: ArrayBuffer,
                offset: number,
                cLength: number,
                eLength: number,
                removeAction: number,
                retainedAction: number,
                addedAction: number,
                rootEntity: number
            ): boolean
            update(
                buffer: ArrayBuffer,
                offset: number,
                cLength: number,
                eLength: number,
                removeAction: number,
                retainedAction: number,
                addedAction: number
            ): boolean
            writeDefaultValues(): void
        }
    }
    export interface INativeWorker {
        createCullingComponentPool(count: number): IHandle
        createRenderComponent(
            meshCount: number,
            uniformBlock: number,
            attachedNode: number,
            cullingId: number,
            meshRenderType: EMeshRenderType,
            macros?: string
        ): IHandle & {
            setSharedDirty(): void
        }
        changeMeshMacros(mesh: number, macros: string): void
        createAnimator(clipCount: number, nodeCount: number): IHandle
        updateAnimators(data: Uint32Array): void
        createAnimationClipBinding(
            buffer: ArrayBuffer,
            offset: number,
            cLength: number,
            eLength: number,
            useDefaultAddedNodesAction: number,
            rootEntity: number
        ): INativeWorker.IAnimationClipBinding
        createAnimatorControllerModel(layerCount: number): {
            id: number
            buffer: ArrayBuffer
            setMaskAtIndex(
                index: number,
                mask: null | ArrayBuffer,
                offset: number,
                length: number
            ): void
            update(): void
        }
        createAnimatorControllerStateModel(clipCount: number): {
            id: number
            buffer: ArrayBuffer
        }
        updateAnimatorControllers(data: Uint32Array): void
        createSkinning(boneCount: number, flag: number): IHandle
        updateSkinnings(data: Uint32Array): void
        createDynamicBones(rootNodeId: number): IHandle & {
            preUpdate(): void
            update(
                dt: number,
                rootMotionX?: number,
                rootMotionY?: number,
                rootMotionZ?: number
            ): void
            rebuild(): void
            resetRoot(rootId: number): void
        }
    }
    export interface INativeWorker {
        createRenderCamera(
            attachedNode: number,
            isUI?: boolean
        ): IHandle & {
            setSharedDirty(): void
            updateMatrices(): void
        }
        createLightCamera(): IHandle
    }
    export interface INativeWorker {
        createAnimationClipModel(buffer: ArrayBuffer): IHandle
        createBoneInverseModel(buffer: ArrayBuffer): IHandle
    }
    export interface INativeWorker {
        eventBusSM: ArrayBuffer
        dirtyNodesSM: ArrayBuffer
        uiRenderList: ArrayBuffer
        enlargeUIRenderList(): void
        refreshNodesWorldTransform(): void
    }
    export interface INativeWorker {
        loadTTFFont(buffer: ArrayBuffer, filaPath: string): string
        getGlyphInfo(name: string, charCode: number): IGlyphInfo
    }
    export interface INativeWorker {
        decodeImage(
            buffer: ArrayBuffer,
            callback: (
                data: ArrayBuffer | undefined,
                width: number,
                height: number
            ) => void,
            premultiplyAlpha: boolean
        ): void
        getRenderEnv(): IRenderEnv
        clearView(view: number): void
        cullCamera(camera: number, cullResult: number, lightMode: string): void
        drawCamera(camera: number, renderList: number, lightMode: string): void
        drawLight(
            light: number,
            camera: number,
            renderList: number,
            lightMode: string
        ): void
        submit(): void
        destroy(): void
        createWeakRef<T>(wrapper: T): {
            deref: () => T
        }
        createWeakRefSentry(): any
        createNativeUUMap(): INativeMap<number>
        createNativeSUMap(): INativeMap<string>
        createNativeULUMap(): ILongIntNativeMap
        decodeBase64(base64: string): ArrayBuffer
        setNodeName(id: number, name: string): void
        setRenderComponentName(id: number, name: string): void
        debugPrint(msg: string): void
    }
    let Phys3D: any
    export const native: {
        worker: INativeWorker
    }
    export function destroy(): void
    export function GET_MAIN_CANVAS(): HTMLCanvasElement
    export function IS_VALID(): boolean
    export { Phys3D }
}

declare module 'XrFrame/loader/glTF/animations/channels/GLTFChannelsNode' {
    import { GLTFArrayNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import { GLTFNodesLoaded } from 'XrFrame/loader/glTF/scenes/GLTFNodesNode'
    import { GLTFSamplersLoaded } from 'XrFrame/loader/glTF/animations/samplers/GLTFSamplersNode'
    import GLTFChannelNode, {
        GLTFChannelLoaded,
        GLTFChannelNodeRaw
    } from 'XrFrame/loader/glTF/animations/channels/GLTFChannelNode'
    type ChildNode = GLTFChannelNode
    export type GLTFChannelsNodeRaw = GLTFChannelsNodeRaw[]
    export type GLTFChannelsLoaded = GLTFChannelLoaded[]
    export default class GLTFChannelsNode extends GLTFArrayNode<ChildNode> {
        ChildCtor(childRaw: GLTFChannelNodeRaw): GLTFChannelNode
        readonly raw: GLTFChannelsNodeRaw
        get nodeName(): string
        preload: (
            prerequisites: [
                nodes: GLTFNodesLoaded,
                samplers: GLTFSamplersLoaded
            ]
        ) => Promise<GLTFChannelsLoaded>
        getLoadedResource(): GLTFChannelsLoaded
    }
    export {}
}

declare module 'XrFrame/loader/glTF/animations/samplers/GLTFSamplersNode' {
    import { GLTFAccessorsLoaded } from 'XrFrame/loader/glTF/buffers/GLTFAccessorsNode'
    import { GLTFArrayNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import GLTFSamplerNode, {
        GLTFSamplerLoaded,
        GLTFSamplerNodeRaw
    } from 'XrFrame/loader/glTF/animations/samplers/GLTFSamplerNode'
    type ChildNode = GLTFSamplerNode
    export type GLTFSamplersNodeRaw = GLTFSamplersNodeRaw[]
    export type GLTFSamplersLoaded = GLTFSamplerLoaded[]
    export default class GLTFSamplersNode extends GLTFArrayNode<ChildNode> {
        ChildCtor(childRaw: GLTFSamplerNodeRaw): GLTFSamplerNode
        readonly raw: GLTFSamplersNodeRaw
        get nodeName(): string
        preload: (
            prerequisites: [accessors: GLTFAccessorsLoaded]
        ) => Promise<GLTFSamplersLoaded>
        getLoadedResource(): GLTFSamplersLoaded
    }
    export {}
}

declare module 'XrFrame/loader/glTF/geometry/primitives/GLTFPrimitivesNode' {
    import { Kanata } from 'XrFrame/ext'
    import { GLTFAccessorsLoaded } from 'XrFrame/loader/glTF/buffers/GLTFAccessorsNode'
    import { GLTFArrayNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import { GLTFMaterialsLoaded } from 'XrFrame/loader/glTF/materials/GLTFMaterialsNode'
    import GLTFPrimitiveNode, {
        GLTFPrimitiveLoaded,
        GLTFPrimitiveNodeRaw
    } from 'XrFrame/loader/glTF/geometry/primitives/GLTFPrimitiveNode'
    type ChildNode = GLTFPrimitiveNode
    export type GLTFPrimitivesNodeRaw = GLTFPrimitivesNodeRaw[]
    export type GLTFPrimitivesLoaded = GLTFPrimitiveLoaded[]
    export default class GLTFPrimitivesNode extends GLTFArrayNode<ChildNode> {
        ChildCtor(childRaw: GLTFPrimitiveNodeRaw): GLTFPrimitiveNode
        readonly raw: GLTFPrimitivesNodeRaw
        get nodeName(): string
        preload: (
            prerequisites: [
                materials: GLTFMaterialsLoaded,
                accessors: GLTFAccessorsLoaded,
                vbMap: Map<string, [ArrayBuffer, Kanata.VertexLayout, object]>
            ]
        ) => Promise<GLTFPrimitivesLoaded>
        getLoadedResource(): GLTFPrimitivesLoaded
    }
    export {}
}

declare module 'XrFrame/loader/glTF/materials/texture/GLTFTextureInfoNode' {
    import { GLTFBaseNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    export interface GLTFTextureInfoNodeRaw {
        index: number
        texCoord?: number
    }
    export interface GLTFTextureInfoLoaded {
        index: number
        texCoord: number
    }
    export default class GLTFTextureInfoNode extends GLTFBaseNode {
        get nodeName(): string
        readonly raw: GLTFTextureInfoNodeRaw
        build(): void
        preload(): Promise<GLTFTextureInfoLoaded>
        getLoadedResource(): GLTFTextureInfoLoaded
    }
}

declare module 'XrFrame/loader/glTF/materials/pbr/GLTFPBRMetallicRoughnessNode' {
    import { Kanata } from 'XrFrame/ext'
    import { GLTFBaseNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import { GLTFTexturesLoaded } from 'XrFrame/loader/glTF/textures/GLTFTexturesNode'
    import { GLTFTextureInfoNodeRaw } from 'XrFrame/loader/glTF/materials/texture/GLTFTextureInfoNode'
    export interface GLTFPBRMetallicRoughnessNodeRaw {
        baseColorFactor?: [number, number, number, number]
        baseColorTexture?: GLTFTextureInfoNodeRaw
        metallicFactor?: number
        roughnessFactor?: number
        metallicRoughnessTexture?: GLTFTextureInfoNodeRaw
    }
    export interface GLTFPBRMetallicRoughnessLoaded {
        uniform: {
            [key: string]: ArrayLike<number> | number | Kanata.Texture
        }
        renderStates: object
        macros: {
            [key: string]: boolean | number
        }
    }
    export default class GLTFPBRMetallicRoughnessNode extends GLTFBaseNode {
        get nodeName(): string
        readonly raw: GLTFPBRMetallicRoughnessNodeRaw
        build(): void
        preload(
            prerequisites: [textrues: GLTFTexturesLoaded]
        ): Promise<GLTFPBRMetallicRoughnessLoaded>
        getLoadedResource(): GLTFPBRMetallicRoughnessLoaded
    }
}

declare module 'XrFrame/loader/glTF/materials/texture/GLTFNormalTextureInfoNode' {
    import { GLTFBaseNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    export interface GLTFNormalTextureInfoNodeRaw {
        index: number
        texCoord?: number
        scale?: number
    }
    export interface GLTFNormalTextureInfoLoaded {
        index: number
        texCoord: number
        scale: number
    }
    export default class GLTFNormalTextureInfoNode extends GLTFBaseNode {
        get nodeName(): string
        readonly raw: GLTFNormalTextureInfoNodeRaw
        build(): void
        preload(): Promise<GLTFNormalTextureInfoLoaded>
        getLoadedResource(): GLTFNormalTextureInfoLoaded
    }
}

declare module 'XrFrame/loader/glTF/materials/texture/GLTFOcclusionTextureInfoNode' {
    import { GLTFBaseNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    export interface GLTFOcclusionTextureInfoNodeRaw {
        index: number
        texCoord?: number
        strength?: number
    }
    export interface GLTFOcclusionTextureInfoLoaded {
        index: number
        texCoord: number
        strength: number
    }
    export default class GLTFOcclusionTextureInfoNode extends GLTFBaseNode {
        get nodeName(): string
        readonly raw: GLTFOcclusionTextureInfoNodeRaw
        build(): void
        preload(): Promise<GLTFOcclusionTextureInfoLoaded>
        getLoadedResource(): GLTFOcclusionTextureInfoLoaded
    }
}

declare module 'XrFrame/kanata/lib/backend/interface/IWorker' {
    /**
     * IWorker.ts
     *
     *       * @Date    : 12/3/2020, 4:45:58 PM
     */
    import {
        IHandle,
        ETextureType,
        ETextureFormat,
        IRect,
        EMeshRenderType,
        INativeMap,
        ILongIntNativeMap,
        IGlyphInfo,
        IVertexLayoutOptions,
        IView,
        IRenderPassDescriptor,
        IEventBridge,
        IDownloader,
        IUniformDescriptorOptions,
        IFontSetting,
        TTextureSource,
        IImage,
        IVertexDataDescriptorOptions,
        IRenderEnv,
        IEngineSettings
    } from 'XrFrame/kanata/lib/backend/interface'
    global {
        const MAIN_CANVAS: HTMLCanvasElement
        const ENGINE_SETTINGS: IEngineSettings
        const ENGINE_MODE: 'Game' | 'Editor'
        const IS_SUB_CONTEXT: boolean
        const HOST: string
    }
    export interface IWorker {
        createVertexLayout(options: IVertexLayoutOptions): IHandle
        createVertexDataDescriptor(
            options: IVertexDataDescriptorOptions
        ): IHandle
        createVertexBuffer(
            buffer: ArrayBuffer | ArrayBufferView,
            layout: IHandle
        ): IHandle
        updateVertexBuffer(
            bufferHandle: IHandle,
            buffer: ArrayBuffer | ArrayBufferView,
            offset: number
        ): void
        createIndexBuffer(
            buffer: ArrayBuffer | ArrayBufferView,
            is32bits?: boolean
        ): IHandle
        updateIndexBuffer(
            bufferHandle: IHandle,
            buffer: ArrayBuffer | ArrayBufferView,
            offset: number
        ): void
        createVertexData(
            layout: IHandle,
            size: number,
            batchDesc: IHandle
        ): IHandle
        createIndexData(size: number): IHandle
        createTexture(
            type: ETextureType,
            width: number,
            height: number,
            slice: number,
            mips: number,
            format: ETextureFormat,
            flags: number,
            source: TTextureSource[],
            offsets: Uint32Array
        ): IHandle
        createAutoUpdateTextureFromCanvas(canvas: HTMLCanvasElement): IHandle
        updateTexture(
            handle: IHandle,
            level: number,
            slice: number,
            xoffset: number,
            yoffset: number,
            zoffset: number,
            width: number,
            height: number,
            buffer:
                | ArrayBuffer
                | ArrayBufferView
                | IImage
                | HTMLCanvasElement
                | ImageData
        ): void
        updateTextureFlags(texture: IHandle, flags: number): void
        createUniformBlockDescriptor(
            descriptor: IUniformDescriptorOptions
        ): IHandle
        createUniformBlock(descriptor: IHandle): IHandle
        createEffect(
            name: string,
            passCount: number,
            keyIndexMap: string[],
            passes: Array<{
                lightMode: string
                variants?: {
                    [key: number]: number
                }
                macros?: {
                    [key: string]: number
                }
                shaders?: number[]
            }>,
            shaders: string[],
            variants: number[][],
            useRuntimeMacros: boolean
        ): IHandle & {
            warmUp(): void
        }
        createMaterial(
            macros?: {
                [name: string]: string | number | boolean
            },
            uniformBlock?: IHandle
        ): IHandle
        changeMaterialMacros(
            material: IHandle,
            macros: {
                [name: string]: string | number | boolean
            },
            reset?: boolean
        ): void
    }
    export interface IWorker {
        createView(view: IView): IHandle
        updateViewRect(view: IHandle, rect: IRect): void
        updateViewScissor(view: IHandle, rect: IRect): void
    }
    export interface IWorker {
        createRenderPass(descriptor: IRenderPassDescriptor): IHandle
    }
    export interface IWorker {
        createNodePool(count: number, is3d: boolean): IHandle
        createNodeTree(
            length: number,
            ids: ArrayBuffer,
            buffer: ArrayBuffer,
            calculateWordMatrix: boolean,
            is3d: boolean
        ): boolean
    }
    export interface IWorker {
        createCullingComponentPool(count: number): IHandle
        createRenderComponent(
            meshCount: number,
            uniformBlock: IHandle,
            attachedNodeId: number,
            cullingCompId: number,
            meshRenderType: EMeshRenderType,
            macros?: {
                [name: string]: string | number | boolean
            }
        ): IHandle & {
            setSharedDirty(): void
        }
        changeMeshMacros(
            mesh: IHandle,
            macros: {
                [name: string]: string | number | boolean
            },
            reset?: boolean
        ): void
        createAnimator(clipCount: number, nodeCount: number): IHandle
        updateAnimators(
            feObjects: Array<{
                __handle: IHandle
                id: number
            }>,
            size: number
        ): void
        createAnimationClipBinding(
            clipArray: Array<{
                __handle: IHandle
                id: number
            }>,
            clipArrayOffset: number,
            clipArrayLength: number,
            entityArray: Array<
                | number
                | {
                      id: number
                  }
                | null
            >,
            entityArrayOffset: number,
            entityArrayLength: number,
            useDefaultAddedNodesAction: number,
            rootEntity: {
                id: number
            }
        ): IHandle
        rebindAnimationClipBinding(
            binding: IHandle,
            clipArray: Array<{
                __handle: IHandle
                id: number
            }>,
            clipArrayOffset: number,
            clipArrayLength: number,
            entityArray: Array<
                | number
                | {
                      id: number
                  }
                | null
            >,
            entityArrayOffset: number,
            entityArrayLength: number,
            removeAction: number,
            retainedAction: number,
            addedAction: number,
            rootEntity: {
                id: number
            }
        ): boolean
        updateAnimationClipBinding(
            binding: IHandle,
            clipArray: Array<{
                __handle: IHandle
                id: number
            }>,
            clipArrayOffset: number,
            clipArrayLength: number,
            entityArray: Array<
                | number
                | {
                      id: number
                  }
                | null
            >,
            entityArrayOffset: number,
            entityArrayLength: number,
            removeAction: number,
            retainedAction: number,
            addedAction: number
        ): boolean
        writeAnimationClipBindingDefaultValues(binding: IHandle): void
        createAnimatorControllerModel(layerCount: number): IHandle
        setAnimatorControllerModelMaskAtIndex(
            model: IHandle,
            index: number,
            mask: {
                buffer: null | ArrayBuffer
                offset: number
                length: number
            }
        ): void
        updateAnimatorControllerModel(model: IHandle): void
        createAnimatorControllerStateModel(clipCount: number): IHandle
        updateAnimatorControllers( // for performance
            feObjects: Array<{
                __handle: IHandle
                id: number
            }>,
            size: number
        ): void
        createSkinning(boneCount: number, flag: number): IHandle
        updateSkinnings(
            feObjects: Array<{
                __handle: IHandle
                id: number
            }>,
            size: number
        ): void
        createDynamicBones(rootNodeId: number): IHandle & {
            preUpdate(): void
            update(
                dt: number,
                rootMotionX?: number,
                rootMotionY?: number,
                rootMotionZ?: number
            ): void
            rebuild(): void
            resetRoot(rootId: number): void
        }
    }
    export interface IWorker {
        createRenderCamera(
            attachedNodeId: number,
            isUI?: boolean
        ): IHandle & {
            setSharedDirty(): void
            updateMatrices(): void
        }
        createLightCamera(): IHandle
    }
    export interface IWorker {
        createAnimationClipModel(buffer: ArrayBuffer): IHandle
        createBoneInverseModel(buffer: ArrayBuffer): IHandle
        createScalableList(
            initSize: number,
            onBackendEnlarge?: () => void
        ): IHandle & {
            enlarge(size: number): void
        }
    }
    export interface IWorker {
        eventBridge: IEventBridge
    }
    export interface IWorker {
        loadTTFFont(url: string, callback: (font: string) => void): void
        getGlyphInfo(fontSetting: IFontSetting, charCode: number): IGlyphInfo
    }
    export interface IWorker {
        setGlobalPhysicSystem(system: any): void
        bindRigidBodyToNode(rigidBody: any, nodeId: number): void
        unbindRigidBody(rigidBody: any): void
        bindCCTToNode(cc: any, nodeId: number): void
        unbindCCT(cc: any): void
    }
    export interface IWorker {
        downloader: IDownloader
        update(delta: number): void
        destroy(): void
        refreshNodesWorldTransform(): void
        getRenderEnv(): IRenderEnv
        clearView(view: IHandle): void
        cullCamera(
            camera: IHandle,
            cullResult: IHandle,
            lightMode: string
        ): void
        drawCamera(
            camera: IHandle,
            renderList: IHandle,
            lightMode: string
        ): void
        drawLight(
            light: IHandle,
            camera: IHandle,
            renderList: IHandle,
            lightMode: string
        ): void
        submit(): void
        createWeakRef<T>(wrapper: T): {
            deref: () => T
        }
        createWeakRefSentry(): any
        createNativeUUMap(): INativeMap<number>
        createNativeSUMap(): INativeMap<string>
        createNativeULUMap(): ILongIntNativeMap
        decodeBase64(base64: string): ArrayBuffer
        setNodeName(id: number, name: string): void
        setRenderComponentName(handle: IHandle, name: string): void
        debugPrint(msg: string): void
    }
}

declare module 'XrFrame/kanata/lib/frontend/pool/Pool' {
    import { IHandle } from 'XrFrame/kanata/lib/backend'
    import NativeObject from 'XrFrame/kanata/lib/frontend/shared/NativeObject'
    export default class Pool extends NativeObject {
        u32viewExt: Uint32Array
        constructor(nativeObj: IHandle)
        supplyExtendedMemory(buffer: ArrayBuffer): void
    }
}

declare module 'XrFrame/loader/glTF/animations/channels/GLTFChannelNode' {
    import { StreamReader } from 'XrFrame/core/utils'
    import { GLTFBaseNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import { GLTFNodesLoaded } from 'XrFrame/loader/glTF/scenes/GLTFNodesNode'
    import { GLTF } from 'XrFrame/loader/glTF/utils/types'
    import { GLTFSamplerLoaded } from 'XrFrame/loader/glTF/animations/samplers/GLTFSamplerNode'
    import { GLTFSamplersLoaded } from 'XrFrame/loader/glTF/animations/samplers/GLTFSamplersNode'
    import {
        GLTFTargetLoaded,
        GLTFTargetNodeRaw
    } from 'XrFrame/loader/glTF/animations/channels/GLTFTargetNode'
    export enum EnumPuppetAnimationSampleGroupType {
        tx = 1,
        ty = 2,
        tz = 3,
        sx = 4,
        sy = 5,
        sz = 6,
        qx = 7,
        qy = 8,
        qz = 9,
        qw = 10,
        ex = 11,
        ey = 12,
        ez = 13
    }
    /**
     * 二进制格式, byteLength = 12 + 16 * samples.len
     * | Array<| nodeid | type | count |> |
     * | Array<PuppetAnimationClipSample> |
     */
    export type PuppetAnimationSampleGroup = ArrayBuffer | GLTF.BufferView
    /**
     * 二进制格式, byteLength = 16
     * uint32_t index;
     * float value;
     * float in_tangent;
     * float out_tangent;
     *
     * @remind out_tangent的值决定了插值的类型！很hack！
     * out_tangent = Infinity: STEP
     * out_tangent = NaN: Spherical Linear Interpolation (for quaternion)
     * out_tangent为正常值: Cubic Spline Interpolation (or Linear)
     */
    export type PuppetAnimationClipSample = ArrayBuffer | GLTF.BufferView
    export interface GLTFChannelNodeRaw {
        sampler: number
        target: GLTFTargetNodeRaw
    }
    export interface GLTFChannelLoaded {
        sampler: GLTFSamplerLoaded
        target: GLTFTargetLoaded
        vectorGroups: number
        headerBytesNeeded: number
        bodyBytesNeeded: number
        serializeHeaderOnBuffer(
            stream: StreamReader,
            channelIndex: number
        ): void
        serializeBodyOnBuffer(stream: StreamReader): number
        morphNodeCount: number
    }
    export default class GLTFChannelNode extends GLTFBaseNode {
        get nodeName(): string
        readonly raw: GLTFChannelNodeRaw
        build(): void
        preload(
            prerequisites: [
                nodes: GLTFNodesLoaded,
                samplers: GLTFSamplersLoaded
            ]
        ): Promise<GLTFChannelLoaded>
        getLoadedResource(): GLTFChannelLoaded
    }
}

declare module 'XrFrame/loader/glTF/animations/samplers/GLTFSamplerNode' {
    import { GLTFAccessorLoaded } from 'XrFrame/loader/glTF/buffers/GLTFAccessorNode'
    import { GLTFAccessorsLoaded } from 'XrFrame/loader/glTF/buffers/GLTFAccessorsNode'
    import { GLTFBaseNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    export enum EnumGLTFSamplerInterpolation {
        STEP = 0,
        LINEAR = 1,
        CUBICSPLINE = 2
    }
    export interface GLTFSamplerNodeRaw {
        input: number
        output: number
        interpolation?: 'STEP' | 'LINEAR' | 'CUBICSPLINE'
    }
    export interface GLTFSamplerLoaded {
        input: GLTFAccessorLoaded
        output: GLTFAccessorLoaded
        interpolation: EnumGLTFSamplerInterpolation
        sampleCount: number
    }
    export default class GLTFSamplerNode extends GLTFBaseNode {
        get nodeName(): string
        readonly raw: GLTFSamplerNodeRaw
        build(): void
        preload(
            prerequisites: [accessors: GLTFAccessorsLoaded]
        ): Promise<GLTFSamplerLoaded>
        getLoadedResource(): GLTFSamplerLoaded
    }
}

declare module 'XrFrame/loader/glTF/geometry/primitives/GLTFPrimitiveNode' {
    import Geometry from 'XrFrame/assets/Geometry'
    import { GLTFAccessorsLoaded } from 'XrFrame/loader/glTF/buffers/GLTFAccessorsNode'
    import { GLTFBaseNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import { GLTFAttributesNodeRaw } from 'XrFrame/loader/glTF/geometry/primitives/attributes/GLTFAttributesNode'
    import { GLTFMaterialsLoaded } from 'XrFrame/loader/glTF/materials/GLTFMaterialsNode'
    import Material from 'XrFrame/assets/Material'
    import { GLTF } from 'XrFrame/loader/glTF/utils/types'
    import { GLTFTargetsNodeRaw } from 'XrFrame/loader/glTF/geometry/primitives/targets/GLTFTargetsNode'
    export enum EnumGLTFPrimitiveMode {
        POINTS = 0,
        LINES = 1,
        LINE_LOOP = 2,
        LINE_STRIP = 3,
        TRIANGLES = 4,
        TRIANGLE_STRIP = 5,
        TRIANGLE_FAN = 6
    }
    export interface GLTFPrimitiveNodeRaw {
        attributes: GLTFAttributesNodeRaw
        indices?: number
        material?: number
        mode?: number
        targets?: GLTFTargetsNodeRaw
    }
    export interface GLTFPrimitiveLoaded {
        geometry: Geometry
        material: Material
    }
    export default class GLTFPrimitiveNode extends GLTFBaseNode {
        get nodeName(): string
        readonly raw: GLTFPrimitiveNodeRaw
        build(): void
        preload(
            prerequisites: [
                materials: GLTFMaterialsLoaded,
                accessors: GLTFAccessorsLoaded,
                vbMap: Map<string, GLTF.VertexProperties>
            ]
        ): Promise<GLTFPrimitiveLoaded>
        getLoadedResource(): GLTFPrimitiveLoaded
    }
}

declare module 'XrFrame/core/utils' {
    export function assert(pred: boolean, msg: string): void
    export function decode(data: ArrayBuffer, format: 'utf-8' | 'gbk'): string
    export function wxPromiseWrapper<T = any>(
        executor: any,
        args: any
    ): Promise<T>
    export class StreamReader {
        constructor(buffer: ArrayBuffer, byteOffset?: number)
        get size(): number
        read<T>(type: StreamReader.Type): T
        write<T>(type: StreamReader.Type, value: T): void
        /**
         * 跳过一个位置，以后再填写。
         */
        reserve<T>(type: StreamReader.Type): {
            write(value: T): void
        }
        readChunk(length: number): ArrayBuffer
        align(alignment: number): void
        end(): boolean
        pos(): number
    }
    export namespace StreamReader {
        enum Type {
            Float = 0,
            UInt32 = 1,
            UInt16 = 2
        }
        const TypeAlignment: {
            0: number
            1: number
            2: number
        }
        const TypeSize: {
            0: number
            1: number
            2: number
        }
    }
}

declare module 'XrFrame/loader/glTF/animations/channels/GLTFTargetNode' {
    import { GLTFBaseNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import {
        GLTFNodesLoaded,
        GLTFTreeNode
    } from 'XrFrame/loader/glTF/scenes/GLTFNodesNode'
    export enum GLTFEnumAnimationTargetPath {
        TRANSLATION = 0,
        ROTATION = 1,
        SCALE = 2,
        WEIGHTS = 3
    }
    export interface GLTFTargetNodeRaw {
        node?: number
        path: 'translation' | 'rotation' | 'scale' | 'weights'
    }
    export interface GLTFTargetLoaded {
        node: GLTFTreeNode | null
        path: GLTFEnumAnimationTargetPath
    }
    export default class GLTFTargetNode extends GLTFBaseNode {
        get nodeName(): string
        readonly raw: GLTFTargetNodeRaw
        build(): void
        preload(
            prerequisites: [nodes: GLTFNodesLoaded]
        ): Promise<GLTFTargetLoaded>
        getLoadedResource(): GLTFTargetLoaded
    }
}

declare module 'XrFrame/loader/glTF/geometry/primitives/attributes/GLTFAttributesNode' {
    import { GLTFAccessorsLoaded } from 'XrFrame/loader/glTF/buffers/GLTFAccessorsNode'
    import { GLTFBaseNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    import { GLTF } from 'XrFrame/loader/glTF/utils/types'
    import { GLTFTargetsLoaded } from 'XrFrame/loader/glTF/geometry/primitives/targets/GLTFTargetsNode'
    /**
     * GLTF.Attributes.Name -> Kanata.Layout.Name
     */
    export function convertAttributeName(name: string): string
    /**
     * GLTF.Attributes.Name -> Kanata.Layout.Format
     * 在shader里不同用途的attribute的长度是固定的，无论他用的accessor实际元素的长度是多少
     */
    export function getComponentCountFromAttributeName(name: string): number
    /**
     * GLTF.Attributes.Name -> Shader Macros
     */
    export function genMacrosByAttrib(name: string, macros: object): void
    export interface GLTFAttributesExtArgs {
        trust?: boolean
        check?: boolean
    }
    export type GLTFAttributesNodeRaw = {
        [attribName: string]: number
    }
    export type GLTFAttributesLoaded = GLTF.VertexProperties
    export default class GLTFAttributesNode extends GLTFBaseNode {
        get nodeName(): string
        readonly raw: GLTFAttributesNodeRaw
        build(): void
        preload(
            prerequisites: [
                targets: GLTFTargetsLoaded,
                materials: any,
                accessors: GLTFAccessorsLoaded,
                vbMap: Map<string, GLTF.VertexProperties>
            ]
        ): Promise<GLTFAttributesLoaded>
        getLoadedResource(): GLTFAttributesLoaded
    }
}

declare module 'XrFrame/loader/glTF/geometry/primitives/targets/GLTFTargetsNode' {
    import { GLTFBaseNode } from 'XrFrame/loader/glTF/GLTFBaseNode'
    export type GLTFTargetsNodeRaw = Array<{
        [targetAttribName: string]: number
    }>
    export interface GLTFTargetsLoaded {
        attributes: {
            [targetAttribName: string]: number
        }
    }
    export const validMorphAttribs: string[]
    export default class GLTFTargetsNode extends GLTFBaseNode {
        get nodeName(): string
        readonly raw: GLTFTargetsNodeRaw
        build(): void
        preload(): Promise<GLTFTargetsLoaded>
        getLoadedResource(): GLTFTargetsLoaded
    }
}
